@MainActor
struct BorderApplier: ParameterApplier {
    // MARK: - Data
    private let border: Border
    
    // MARK: - Inits
    init(border: Border) {
        self.border = border
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UIView) {
        element.layer.borderWidth = border.width
        element.layer.borderColor = border.colorMap.color(for: element).cgColor
    }
}
