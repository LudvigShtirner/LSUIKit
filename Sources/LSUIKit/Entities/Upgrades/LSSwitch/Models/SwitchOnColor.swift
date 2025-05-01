public struct SwitchOnColor: ParameterApplier {
    // MARK: - Data
    private let onColor: ColorMap
    
    // MARK: - Inits
    init(onColor: ColorMap) {
        self.onColor = onColor
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UISwitch) {
        element.onTintColor = onColor.color(for: element)
    }
}
