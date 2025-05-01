struct LSCollectionDataCellModelErased: Identifiable, Hashable {
    let cellModel: any LSCollectionDataCellModel
    
    var id: String { cellModel.uniqueIdentifier }
    
    static func == (lhs: LSCollectionDataCellModelErased, rhs: LSCollectionDataCellModelErased) -> Bool {
        lhs.cellModel.isEqual(to: rhs.cellModel)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
