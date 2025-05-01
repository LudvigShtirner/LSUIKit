public protocol LSCollectionDataCellModel: Equatable, Sendable {
    associatedtype CellType: UICollectionViewCell
    var cellType: UICollectionViewCell.Type { get }
    func makeCell(of collectionView: UICollectionView, indexPath: IndexPath) -> CellType
    func isEqual(to cellModel: any LSCollectionDataCellModel) -> Bool
    
    var uniqueIdentifier: String { get }
    
    var selectAction: SendableVoidBlock? { get }
    var deselectAction: SendableVoidBlock? { get }
    var willDisplayAction: SendableVoidBlock? { get }
    var didEndDisplayAction: SendableVoidBlock? { get }
    var performPrimaryAction: SendableVoidBlock? { get }
    
    var isEditable: Bool { get }
    var selection: LSCellSelection { get }
    var highlightable: LSCellHighlightable { get }
    
    var sizeProvider: (UICollectionView, UICollectionViewLayout) -> CGSize { get }
}

public enum LSCellHighlightable {
    case no
    case has(
        highlightAction: SendableVoidBlock,
        unhighlightAction: SendableVoidBlock?
    )
    
    var highlightAction: SendableVoidBlock? {
        switch self {
            case let .has(highlightAction, _):
                return highlightAction
            case .no:
                return nil
        }
    }
    
    var unhighlightAction: SendableVoidBlock? {
        switch self {
            case let .has(_, unhighlightAction):
                return unhighlightAction
            case .no:
                return nil
        }
    }
}
