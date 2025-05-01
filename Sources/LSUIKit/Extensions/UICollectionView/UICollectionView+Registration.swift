public extension UICollectionView {
    /// Register cell for UICollectionView pool
    ///
    /// Example of usage:
    /// ```
    /// collectionView.registerCell(ExampleCollectionViewCell.self)
    /// ```
    func registerCell<Cell: UICollectionViewCell>(_: Cell.Type) {
        register(Cell.self, forCellWithReuseIdentifier: Cell.className)
    }
    
    /// Register nib cell for UICollectionView pool
    ///
    /// Example of usage:
    /// ```
    /// collectionView.registerNibCell(ExampleCollectionViewCell.self)
    /// ```
    func registerNibCell<Cell: NibReusable>(_ cell: Cell.Type) {
        let nib = UINib(nibName: cell.nibName, bundle: Bundle(for: cell))
        register(nib, forCellWithReuseIdentifier: cell.className)
    }
    
    /// Register supplementary view for UICollectionView pool
    ///
    /// Example of usage:
    /// ```
    /// collectionView.registerView(ExampleHeaderView.self, forSupplementaryViewOfKind: .header)
    /// ```
    func registerView<View: UICollectionReusableView>(_: View.Type,
                                                      forSupplementaryViewOfKind kind: SupplementaryViewKind) {
        register(View.self,
                 forSupplementaryViewOfKind: kind.identifier,
                 withReuseIdentifier: View.className)
    }
    
    /// Зарегистрировать вспомогательное отображение секции
    /// - Parameters:
    ///   - view: класс вспомогательного отображения секции
    ///   - kind: тип вспомогательного отображения
    func registerNibView<View: NibReusable>(_ view: View.Type, forSupplementaryViewOfKind kind: SupplementaryViewKind) {
        let nib = UINib(nibName: view.nibName, bundle: Bundle(for: view))
        register(nib,
                 forSupplementaryViewOfKind: kind.identifier,
                 withReuseIdentifier: view.className)
    }
    
    /// Dequeue cell from pool or create a new one
    /// - Warning: Application will be crashed if cell isn't registered
    ///
    /// Example of usage:
    /// ```
    /// let cell: ExampleCollectionViewCell = collectionView.dequeueCell(for: indexPath)
    /// cell.configure(model: someModel)
    /// return cell
    /// ```
    /// - Returns: instance of expected Cell class
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as? T else {
            assertionFailure("Could not dequeue cell with identifier: \(T.className)")
            return T.init()
        }
        return cell
    }
    
    /// Dequeue supplementary view from pool or create a new one
    ///
    /// Example of usage:
    /// ```
    /// let view: ExampleHeaderView = collectionView.dequeueView(forSupplementaryViewOfKind: .header, indexPath: IndexPath)
    /// view.configure(model: someModel)
    /// return view
    /// ```
    /// - Returns: instance of expected SupplementaryView class
    func dequeueView<T: UIView>(forSupplementaryViewOfKind kind: SupplementaryViewKind,
                                indexPath: IndexPath) -> T where T: Identifiable {
        let view = dequeueReusableSupplementaryView(ofKind: kind.identifier,
                                                    withReuseIdentifier: T.className,
                                                    for: indexPath)
        guard let result = view as? T else {
            assertionFailure("Could not dequeue SupplementaryView with identifier: \(T.className)")
            return T.init()
        }
        return result
    }
}

/// Enumeration of UICollectionView supplementary view kinds.
///
/// That is proxy object to use UIKit constants for supplementary view kinds
@MainActor
public enum SupplementaryViewKind {
    case header
    case footer
    
    internal var identifier: String {
        switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

