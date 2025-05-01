public final class LSTableDataSnapshot {
    public let sections: [LSTableDataSection]
    
    public init(sections: [LSTableDataSection]) {
        self.sections = sections
    }
    
    var isEmpty: Bool {
        sections.isEmpty || !sections.contains(where: { section in
            section.isEmpty == false
        })
    }
    
    func getModel(at indexPath: IndexPath) -> (any LSTableDataCellModel)? {
        getSection(at: indexPath.section)?
            .models[safe: indexPath.row]
    }
    
    func getSection(at section: Int) -> (any LSTableDataSection)? {
        sections[safe: section]
    }
}
