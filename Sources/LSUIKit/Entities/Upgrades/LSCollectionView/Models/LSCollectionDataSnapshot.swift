public struct LSCollectionDataSnapshot: Sendable {
    public let sections: [LSCollectionDataSection]
    
    public init(sections: [LSCollectionDataSection]) {
        self.sections = sections
    }
    
    var isEmpty: Bool {
        sections.isEmpty || !sections.contains(where: { section in
            section.isEmpty == false
        })
    }
    
    func getModel(at indexPath: IndexPath) -> (any LSCollectionDataCellModel)? {
        getSection(at: indexPath.section)?
            .models[safe: indexPath.row]
    }
    
    func getSection(at section: Int) -> (any LSCollectionDataSection)? {
        sections[safe: section]
    }
}
