public protocol LSTableDataCellModel: Equatable, Sendable {
    associatedtype CellType: UITableViewCell
    var cellType: UITableViewCell.Type { get }
    func makeCell(of tableView: UITableView, indexPath: IndexPath) -> CellType
    func isEqual(to cellModel: any LSTableDataCellModel) -> Bool
    
    var uniqueIdentifier: String { get }
    
    var selectAction: SendableVoidBlock? { get }
    var deselectAction: SendableVoidBlock? { get }
    var willDisplayAction: SendableVoidBlock? { get }
    var didEndDisplayAction: SendableVoidBlock? { get }
    
    var isEditable: Bool { get }
    var selection: LSCellSelection { get }
}

public enum LSCellSelection {
    case nonSelectable
    case selectable(isSelected: Bool)
    
    var isSelected: Bool {
        switch self {
            case .nonSelectable: return false
            case .selectable(let isSelected):
                return isSelected
        }
    }
    
    var isSelectable: Bool {
        switch self {
            case .nonSelectable: return false
            case .selectable: return true
        }
    }
}
