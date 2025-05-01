public struct TitleSet {
    let normalText: String
    let highlightText: String?
    let disabledText: String?
    
    public init(normalText: String,
                highlightText: String? = nil,
                disabledText: String? = nil) {
        self.normalText = normalText
        self.highlightText = highlightText
        self.disabledText = disabledText
    }
}
