public protocol LSSliderInterface: UISlider {
    var sliderDrawer: LSSliderDrawer? { get set }
    var trackingEventHandler: LSSliderTrackingEventHandler? { get set }
    var layoutSubviewsDecorator: LSSliderLayoutSubviewsDecorator? { get set }
    var thumbRectDecorator: LSSliderThumbRectDecorator? { get set }
    
    func useThumbImage(_ thumbImage: ImageSet)
    func useThumbTintColor(_ thumbColors: ColorSet)
    func useMinimumTrackColors(_ minimumColors: ColorSet)
    func useMaximumTrackColors(_ maximumColors: ColorSet)
}
