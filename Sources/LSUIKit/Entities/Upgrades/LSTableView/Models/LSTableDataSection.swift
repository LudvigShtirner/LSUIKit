public protocol LSTableDataSection: Sendable {
    var identifier: String { get }
    var models: [any LSTableDataCellModel] { get }
    var headerView: LSTableHeaderFooterModel? { get }
    var footerView: LSTableHeaderFooterModel? { get }
}

extension LSTableDataSection {
    var isEmpty: Bool { models.isEmpty }
}

public struct LSTableHeaderFooterModel {
    let contentType: ContentType
    let height: CGFloat
    
    enum ContentType {
        case headerFooter(UITableViewHeaderFooterView.Type)
        case direct(UIView)
    }
}
