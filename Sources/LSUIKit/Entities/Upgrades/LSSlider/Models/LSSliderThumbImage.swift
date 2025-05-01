struct LSSliderThumbImage: ParameterApplier {
    // MARK: - Data
    private let thumbImage: ImageSet
    
    // MARK: - Inits
    init(thumbImage: ImageSet) {
        self.thumbImage = thumbImage
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UISlider) {
        element.thumbTintColor = .clear
        element.setThumbImage(thumbImage.normalImage, for: .normal)
        element.setThumbImage(thumbImage.highlightImage ?? thumbImage.normalImage, for: .highlighted)
        element.setThumbImage(thumbImage.disabledImage ?? thumbImage.normalImage, for: .disabled)
    }
}
