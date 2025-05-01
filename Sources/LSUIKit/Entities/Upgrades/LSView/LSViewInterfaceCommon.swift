public protocol LSViewInterfaceCommon: UIView {
    var hitTestBehaviour: HitTestBehaviour? { get set }
    
    func useEffect(_ effect: LSVisualEffect)
    func useCornerRadius(_ cornerRadius: CornerRadius)
    func useShadow(_ shadow: Shadow)
    func useLayerMask(_ layerMask: LayerMask)
}

protocol LSViewInterfaceInternalCommon: LSViewInterfaceCommon {
    var lsCornerRadius: CornerRadiusApplier? { get set }
    var lsShadow: ShadowApplier? { get set }
    var lsLayerMask: LayerMaskApplier? { get set }
}

extension LSViewInterfaceInternalCommon {
    public func useEffect(_ effect: LSVisualEffect) {
        let effectApplier = VisualEffectApplier(value: effect)
        effectApplier.apply(to: self)
    }
    
    public func useCornerRadius(_ cornerRadius: CornerRadius) {
        self.lsCornerRadius = CornerRadiusApplier(value: cornerRadius)
        self.lsCornerRadius?.apply(to: self)
    }
    
    public func useShadow(_ shadow: Shadow) {
        self.lsShadow = ShadowApplier(value: shadow)
        self.lsShadow?.apply(to: self)
    }
    
    public func useLayerMask(_ layerMask: LayerMask) {
        self.lsLayerMask = LayerMaskApplier(layerMask: layerMask)
        self.lsLayerMask?.apply(to: self)
    }
}
