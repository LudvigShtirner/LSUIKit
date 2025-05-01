struct LSTableDataSectionErased: Identifiable, Hashable, Sendable {
    let unwrapped: any LSTableDataSection

    var id: String { unwrapped.identifier }

    static func == (lhs: LSTableDataSectionErased, rhs: LSTableDataSectionErased) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
