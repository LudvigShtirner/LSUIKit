@MainActor
struct CornerRadiusApplier: ParameterApplier {
    // MARK: - Data
    private let value: CornerRadius
    
    // MARK: - Inits
    init(value: CornerRadius) {
        self.value = value
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UIView) {
        switch value {
            case let .fixed(cornerRadius):
                element.cornerRadius = cornerRadius
            case .circled:
                element.cornerRadius = element.bounds.minSide.half
            case let .masked(corners, radius):
                element.addRadius(radius, to: corners.caCornerMask)
        }
    }
}

extension UIRectCorner {
    var caCornerMask: CACornerMask {
        var cornersMask = CACornerMask()
        if self.contains(.topLeft) {
            cornersMask.insert(.layerMinXMinYCorner)
        }
        if self.contains(.topRight) {
            cornersMask.insert(.layerMaxXMinYCorner)
        }
        if self.contains(.bottomLeft) {
            cornersMask.insert(.layerMinXMaxYCorner)
        }
        if self.contains(.bottomRight) {
            cornersMask.insert(.layerMaxXMaxYCorner)
        }
        return cornersMask
    }
}
