struct LSCollectionDataSectionErased: Identifiable, Hashable, Sendable {
    let unwrapped: any LSCollectionDataSection

    var id: String { unwrapped.identifier }

    static func == (lhs: LSCollectionDataSectionErased, rhs: LSCollectionDataSectionErased) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
