public protocol LSCollectionDataSection: Sendable {
    var identifier: String { get }
    var models: [any LSCollectionDataCellModel] { get }
    var headerView: LSCollectionHeaderFooterModel? { get }
    var footerView: LSCollectionHeaderFooterModel? { get }
    
    var insets: UIEdgeInsets { get }
    var itemSpacing: CGFloat { get }
    var lineSpacing: CGFloat { get }
}

extension LSCollectionDataSection {
    var isEmpty: Bool { models.isEmpty }
}

public struct LSCollectionHeaderFooterModel {
    let contentType: ContentType
    let size: CGSize
    
    enum ContentType {
        case headerFooter(UICollectionReusableView.Type)
        case direct(UIView)
    }
}
