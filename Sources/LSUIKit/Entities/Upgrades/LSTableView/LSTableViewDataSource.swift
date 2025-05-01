@MainActor
final class LSTableViewDataSource: NSObject {
    
    private var dataSource: UITableViewDiffableDataSource<LSTableDataSectionErased, LSTableDataCellModelErased>!
    private var currentSnapshot = NSDiffableDataSourceSnapshot<LSTableDataSectionErased, LSTableDataCellModelErased>()
    
    private var snapshot = LSTableDataSnapshot(sections: [])
    private var registeredCells = Set<String>()
    private var isScrolling = false
    private var scrollHandleAction: ((CGPoint) -> Void)?
    
    init(tableView: UITableView) {
        super.init()
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, _ in
            guard let self, let model = snapshot.getModel(at: indexPath) else { return UITableViewCell() }
            if registeredCells.contains(model.cellType.className) {
                tableView.registerCell(model.cellType)
                registeredCells.insert(model.cellType.className)
            }
            let cell = model.makeCell(of: tableView, indexPath: indexPath)
            return cell
        }
        tableView.dataSource = dataSource
        tableView.delegate = self
        dataSource.apply(currentSnapshot)
    }
    
    func reload(
        snapshot: LSTableDataSnapshot,
        animated: Bool,
        completion: VoidBlock?
    ) {
        currentSnapshot = NSDiffableDataSourceSnapshot<LSTableDataSectionErased, LSTableDataCellModelErased>()
        let sections = snapshot.sections.map {
            LSTableDataSectionErased(unwrapped: $0)
        }
        currentSnapshot.appendSections(sections)
        for section in sections {
            let models = section.unwrapped.models.map {
                LSTableDataCellModelErased(cellModel: $0)
            }
            currentSnapshot.appendItems(models, toSection: section)
        }
        dataSource.apply(
            currentSnapshot,
            animatingDifferences: animated,
            completion: completion
        )
    }
}

extension LSTableViewDataSource: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard let model = snapshot.getModel(at: indexPath) else {
            return
        }
        model.willDisplayAction?()
    }
    
    func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard let model = snapshot.getModel(at: indexPath) else {
            return
        }
        model.didEndDisplayAction?()
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let section = snapshot.getSection(at: section),
              let headerModel = section.headerView else {
            return nil
        }
        switch headerModel.contentType {
            case .headerFooter(let className):
                return tableView.dequeueReusableHeaderFooterView(withIdentifier: className.className)
            case .direct(let view):
                return view
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        guard let sectionModel = snapshot.getSection(at: section) else {
            return .zero
        }
        return sectionModel.headerView?.height ?? .zero
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        guard let sectionModel = snapshot.getSection(at: section) else {
            return .zero
        }
        return sectionModel.footerView?.height ?? .zero
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        guard let section = snapshot.getSection(at: section),
              let footerModel = section.footerView else {
            return nil
        }
        switch footerModel.contentType {
            case .headerFooter(let className):
                return tableView.dequeueReusableHeaderFooterView(withIdentifier: className.className)
            case .direct(let view):
                return view
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        guard let model = snapshot.getModel(at: indexPath) else {
            return true
        }
        let cell = tableView.cellForRow(at: indexPath)
        if tableView.isEditing && model.isEditable {
            cell?.selectionStyle = .default
        } else {
            cell?.selectionStyle = .none
        }
        return true
    }
    
    func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        guard let model = snapshot.getModel(at: indexPath),
              model.selection.isSelectable else {
            return nil
        }
        return indexPath
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let model = snapshot.getModel(at: indexPath),
              model.selection.isSelectable else {
            return
        }
        model.selectAction?()
    }
    
    func tableView(
        _ tableView: UITableView,
        didDeselectRowAt indexPath: IndexPath
    ) {
        guard let model = snapshot.getModel(at: indexPath),
              model.selection.isSelectable else {
            return
        }
        model.deselectAction?()
    }
}

// MARK: - UIScrollViewDelegate

extension LSTableViewDataSource: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollHandleAction?(scrollView.contentOffset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
    }
    
    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        if !decelerate {
            isScrolling = false
        }
    }
}
