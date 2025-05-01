struct LSTableDataCellModelErased: Identifiable, Hashable {
    let cellModel: any LSTableDataCellModel
    
    var id: String { cellModel.uniqueIdentifier }
    
    static func == (lhs: LSTableDataCellModelErased, rhs: LSTableDataCellModelErased) -> Bool {
        lhs.cellModel.isEqual(to: rhs.cellModel) 
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
