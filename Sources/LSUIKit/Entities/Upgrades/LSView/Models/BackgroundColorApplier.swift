@MainActor
struct BackgroundColorApplier: ParameterApplier {
    // MARK: - Data
    private let value: ColorMap
    
    // MARK: - Inits
    init(value: ColorMap) {
        self.value = value
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UIView) {
        element.backgroundColor = value.color(for: element)
    }
}
