public protocol LSSliderDrawer: AnyObject {
    func drawSlider(_ slider: LSSlider,
                    rect: CGRect,
                    context: CGContext) -> Bool
}
