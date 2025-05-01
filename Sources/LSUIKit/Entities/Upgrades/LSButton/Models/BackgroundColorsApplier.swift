struct BackgroundColorsApplier: ParameterApplier {
    // MARK: - Data
    private let colorSet: ColorSet
    
    // MARK: - Life cycle
    init(colorSet: ColorSet) {
        self.colorSet = colorSet
    }
    
    // MARK: - ParameterApplier
    @MainActor
    func apply(to element: UIButton) {
        element.backgroundColor = colorSet
            .current(isHighlighted: element.isHighlighted,
                     isEnabled: element.isEnabled)
            .color(for: element)
    }
}
