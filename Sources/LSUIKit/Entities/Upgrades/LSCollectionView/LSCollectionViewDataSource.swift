@MainActor
final class LSCollectionViewDataSource: NSObject {
    private var dataSource: UICollectionViewDiffableDataSource<LSCollectionDataSectionErased, LSCollectionDataCellModelErased>!
    private var currentSnapshot = NSDiffableDataSourceSnapshot<LSCollectionDataSectionErased, LSCollectionDataCellModelErased>()
    
    private var snapshot = LSCollectionDataSnapshot(sections: [])
    private var registeredCells = Set<String>()
    private var isScrolling = false
    private var scrollHandleAction: ((CGPoint) -> Void)?
    
    init(collectionView: UICollectionView) {
        super.init()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, _ in
            guard let self, let model = snapshot.getModel(at: indexPath) else { return UICollectionViewCell() }
            if registeredCells.contains(model.cellType.className) {
                collectionView.registerCell(model.cellType)
                registeredCells.insert(model.cellType.className)
            }
            let cell = model.makeCell(of: collectionView, indexPath: indexPath)
            return cell
        }
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        dataSource.apply(currentSnapshot)
    }
    
    func reload(
        snapshot: LSCollectionDataSnapshot,
        animated: Bool,
        completion: VoidBlock?
    ) {
        currentSnapshot = NSDiffableDataSourceSnapshot<LSCollectionDataSectionErased, LSCollectionDataCellModelErased>()
        let sections = snapshot.sections.map {
            LSCollectionDataSectionErased(unwrapped: $0)
        }
        currentSnapshot.appendSections(sections)
        for section in sections {
            let models = section.unwrapped.models.map {
                LSCollectionDataCellModelErased(cellModel: $0)
            }
            currentSnapshot.appendItems(models, toSection: section)
        }
        dataSource.apply(
            currentSnapshot,
            animatingDifferences: animated,
            completion: completion
        )
    }
    
    func reloadCell(with model: any LSCollectionDataCellModel) {
        let model = LSCollectionDataCellModelErased(cellModel: model)
        currentSnapshot.reloadItems([model])
        dataSource.apply(currentSnapshot)
    }
}

// MARK: - UICollectionViewDelegate
extension LSCollectionViewDataSource: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        snapshot.getModel(at: indexPath)?.selection.isSelectable ?? true
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didHighlightItemAt indexPath: IndexPath
    ) {
        snapshot.getModel(at: indexPath)?.highlightable.highlightAction?()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didUnhighlightItemAt indexPath: IndexPath
    ) {
        snapshot.getModel(at: indexPath)?.highlightable.unhighlightAction?()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        snapshot.getModel(at: indexPath)?.selection.isSelectable ?? true
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        snapshot.getModel(at: indexPath)?.selection.isSelectable ?? true
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        snapshot.getModel(at: indexPath)?.selectAction?()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        snapshot.getModel(at: indexPath)?.deselectAction?()
    }
    
    @available(iOS 16.0, *)
    func collectionView(
        _ collectionView: UICollectionView,
        canPerformPrimaryActionForItemAt indexPath: IndexPath
    ) -> Bool {
        snapshot.getModel(at: indexPath)?.performPrimaryAction != nil
    }
    
    @available(iOS 16.0, *)
    func collectionView(
        _ collectionView: UICollectionView,
        performPrimaryActionForItemAt indexPath: IndexPath
    ) {
        snapshot.getModel(at: indexPath)?.performPrimaryAction?()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        snapshot.getModel(at: indexPath)?.willDisplayAction?()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
#warning("No implementations")
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        snapshot.getModel(at: indexPath)?.didEndDisplayAction?()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplayingSupplementaryView view: UICollectionReusableView,
        forElementOfKind elementKind: String,
        at indexPath: IndexPath
    ) {
#warning("No implementations")
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        transitionLayoutForOldLayout fromLayout: UICollectionViewLayout,
        newLayout toLayout: UICollectionViewLayout
    ) -> UICollectionViewTransitionLayout {
#warning("No implementations")
        return UICollectionViewTransitionLayout(currentLayout: fromLayout,
                                                nextLayout: toLayout)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        canFocusItemAt indexPath: IndexPath
    ) -> Bool {
#warning("No implementations")
        return false
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext
    ) -> Bool {
#warning("No implementations")
        return false
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
        with coordinator: UIFocusAnimationCoordinator
    ) {
#warning("No implementations")
    }
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
#warning("No implementations")
        return nil
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        selectionFollowsFocusForItemAt indexPath: IndexPath
    ) -> Bool {
#warning("No implementations")
        return false
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        targetIndexPathForMoveOfItemFromOriginalIndexPath originalIndexPath: IndexPath,
        atCurrentIndexPath currentIndexPath: IndexPath,
        toProposedIndexPath proposedIndexPath: IndexPath
    ) -> IndexPath {
#warning("No implementations")
        return proposedIndexPath
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint
    ) -> CGPoint {
#warning("No implementations")
        return proposedContentOffset
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        canEditItemAt indexPath: IndexPath
    ) -> Bool {
        snapshot.getModel(at: indexPath)?.isEditable ?? true
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSpringLoadItemAt indexPath: IndexPath,
        with context: any UISpringLoadedInteractionContext
    ) -> Bool {
#warning("No implementations")
        return true
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath
    ) -> Bool {
#warning("No implementations")
        return false
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didBeginMultipleSelectionInteractionAt indexPath: IndexPath
    ) {
#warning("No implementations")
    }
    
    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
#warning("No implementations")
    }
    
    @available(iOS 16, *)
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
#warning("No implementations")
        return nil
    }
    
    @available(iOS 16, *)
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        highlightPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
#warning("No implementations")
        return nil
    }
    
    @available(iOS 16, *)
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        dismissalPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
#warning("No implementations")
        return nil
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
        animator: any UIContextMenuInteractionCommitAnimating
    ) {
#warning("No implementations")
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplayContextMenu configuration: UIContextMenuConfiguration,
        animator: (any UIContextMenuInteractionAnimating)?
    ) {
#warning("No implementations")
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
        animator: (any UIContextMenuInteractionAnimating)?
    ) {
#warning("No implementations")
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        sceneActivationConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIWindowScene.ActivationConfiguration? {
#warning("No implementations")
        return nil
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
#warning("No implementations")
        return nil
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
#warning("No implementations")
        return nil
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
#warning("No implementations")
        return nil
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LSCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let section = snapshot.sections[safe: indexPath.section],
              let model = snapshot.getModel(at: indexPath) else {
            return .zero
        }
        return model.sizeProvider(collectionView, collectionViewLayout)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let model = snapshot.sections[section]
        return model.insets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        let model = snapshot.sections[section]
        return model.lineSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        let model = snapshot.sections[section]
        return model.itemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let model = snapshot.sections[section]
        return model.headerView?.size ?? .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        let model = snapshot.sections[section]
        return model.footerView?.size ?? .zero
    }
}
