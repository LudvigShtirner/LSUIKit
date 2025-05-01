public protocol LSSliderThumbRectDecorator: AnyObject {
    func thumbRect(forBounds bounds: CGRect,
                   trackRect rect: CGRect,
                   value: Float,
                   slider: LSSlider,
                   superAnswer: CGRect) -> CGRect
}
