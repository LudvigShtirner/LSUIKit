public extension UIEdgeInsets {
    @inlinable
    var horizontalInsets: CGFloat { left + right }
    
    @inlinable
    var verticalInsets: CGFloat { top + bottom }
}

