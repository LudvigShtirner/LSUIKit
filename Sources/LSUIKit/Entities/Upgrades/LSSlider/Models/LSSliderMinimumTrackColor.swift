struct LSSliderMinimumTrackColor: ParameterApplier {
    // MARK: - Data
    private let colorSet: ColorSet
    
    // MARK: - Inits
    init(colorSet: ColorSet) {
        self.colorSet = colorSet
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UISlider) {
        let colorMap = colorSet.current(isHighlighted: element.isHighlighted,
                                        isEnabled: element.isEnabled)
        element.minimumTrackTintColor = colorMap.color(for: element)
    }
}
