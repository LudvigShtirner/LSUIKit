public enum CornerRadius {
    case fixed(CGFloat)
    case circled
    case masked(corners: UIRectCorner, radius: CGFloat)
}
