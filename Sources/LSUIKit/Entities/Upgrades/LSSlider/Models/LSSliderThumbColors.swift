struct LSSliderThumbColors: ParameterApplier {
    // MARK: - Data
    private let thumbColors: ColorSet
    
    // MARK: - Inits
    init(thumbColors: ColorSet) {
        self.thumbColors = thumbColors
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UISlider) {
        let colorMap = thumbColors.current(isHighlighted: element.isHighlighted,
                                           isEnabled: element.isEnabled)
        element.thumbTintColor = colorMap.color(for: element)
    }
}
