public extension UIView {
    /// Добавить скругление на перечисленные углы
    /// - Parameters:
    ///   - radius: Радиус скругления
    ///   - corners: углы отображения
    func addRadius(_ radius: CGFloat, to corners: CACornerMask) {
        layer.maskedCorners = corners
        cornerRadius = radius
    }
    
    /// Быстрый доступ к скруглению всех сторон отображения
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
