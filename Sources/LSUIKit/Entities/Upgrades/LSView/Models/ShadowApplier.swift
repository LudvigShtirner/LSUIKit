@MainActor
struct ShadowApplier: ParameterApplier {
    // MARK: - Data
    private let value: Shadow
    
    // MARK: - Inits
    init(value: Shadow) {
        self.value = value
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UIView) {
        element.clipsToBounds = false
        let layer = element.layer
        let cornerRadius = {
            switch value.radius {
            case .circled:
                return element.bounds.minSide.half
            case let .fixed(value):
                return value
            case let .masked(_, radius):
                return radius
            }
        }()
        let corners: UIRectCorner = {
            switch value.radius {
            case .circled, .fixed:
                return .allCorners
            case let .masked(corners, _):
                return corners
            }
        }()
        layer.shadowColor = value.color.color(for: element).cgColor
        layer.shadowRadius = cornerRadius
        layer.shadowOpacity = value.opacity
        layer.shadowOffset = value.offset
        layer.shadowPath = UIBezierPath(roundedRect: element.bounds,
                                        byRoundingCorners: corners,
                                        cornerRadii: .init(width: cornerRadius,
                                                           height: cornerRadius)).cgPath
    }
}
