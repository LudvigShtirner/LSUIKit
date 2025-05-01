public extension UITableView {
    /// Register cell for UITableView pool
    ///
    /// Example of usage:
    /// ```
    /// tableView.registerCell(ExampleTableViewCell.self)
    /// ```
    func registerCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.className)
    }
    
    /// Register Header or Footer view for UITableView pool
    ///
    /// Example of usage:
    /// ```
    /// table.registerView(ExampleHeaderView.self)
    /// ```
    func registerView<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.className)
    }
    
    /// Dequeue cell from pool or create a new one
    ///
    /// Example of usage:
    /// ```
    /// let cell: ExampleTableViewCell = tableView.dequeueCell(for: indexPath)
    /// cell.configure(model: someModel)
    /// return cell
    /// ```
    /// - Warning: Application will be crashed if cell isn't registered
    /// - Returns: instance of expected Cell class
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T else {
            assertionFailure("Could not dequeue cell with identifier: \(T.className)")
            return T.init()
        }
        return cell
    }
    
    /// Dequeue Header or Footer view from pool or create a new one
    ///
    /// Example of usage:
    /// ```
    /// let view: ExampleHeaderView = collectionView.dequeueView(forSupplementaryViewOfKind: .header, indexPath: IndexPath)
    /// view.configure(model: someModel)
    /// return view
    /// ```
    /// - Warning: Application will be crashed if view isn't registered
    /// - Returns: instance of expected SupplementaryView class
    func dequeueView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.className) as? T else {
            assertionFailure("Could not dequeue reusableView with identifier: \(T.className)")
            return T.init()
        }
        return view
    }
}

