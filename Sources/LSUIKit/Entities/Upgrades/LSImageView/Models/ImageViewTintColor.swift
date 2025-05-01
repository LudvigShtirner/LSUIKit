public struct ImageViewTintColor: ParameterApplier {
    // MARK: - Data
    private let tintColor: ColorMap
    
    // MARK: - Inits
    init(tintColor: ColorMap) {
        self.tintColor = tintColor
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UIImageView) {
        element.tintColor = tintColor.color(for: element)
    }
}
