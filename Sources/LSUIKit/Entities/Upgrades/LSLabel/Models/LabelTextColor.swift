struct LabelTextColor: ParameterApplier {
    // MARK: - Data
    private let textColor: ColorMap
    
    // MARK: - Inits
    init(textColor: ColorMap) {
        self.textColor = textColor
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UILabel) {
        element.textColor = textColor.color(for: element)
    }
}
