public protocol LSSliderTrackingEventHandler: AnyObject {
    func beginTracking(_ touch: UITouch,
                       with event: UIEvent?,
                       on slider: LSSlider)
    func endTracking(_ touch: UITouch?,
                     with event: UIEvent?,
                     on slider: LSSlider)
}
