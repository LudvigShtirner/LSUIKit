struct ButtonTintColorApplier: ParameterApplier {
    // MARK: - Data
    private let colorMap: ColorMap
    
    // MARK: - Inits
    init(colorMap: ColorMap) {
        self.colorMap = colorMap
    }
    
    // MARK: - ParameterApplier
    @MainActor
    func apply(to element: UIButton) {
        element.tintColor = colorMap.color(for: element)
    }
}
