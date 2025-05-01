@MainActor
struct LayerMaskApplier: ParameterApplier {
    // MARK: - Data
    private let layerMask: LayerMask
    
    // MARK: - Inits
    init(layerMask: LayerMask) {
        self.layerMask = layerMask
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UIView) {
        switch layerMask {
            case .none:
                element.layer.mask = nil
            case let .path(path, fillRule):
                let mask = CAShapeLayer()
                mask.path = path().cgPath
                mask.fillRule = fillRule
                element.layer.mask = mask
            case let .content(imageClosure):
                guard let image = imageClosure() else {
                    element.layer.mask = nil
                    return
                }
                let mask = CALayer()
                mask.contents = image
                mask.frame = element.bounds
                print("Mask Applied to rect: \(element.bounds)")
                element.layer.mask = mask
        }
    }
}
