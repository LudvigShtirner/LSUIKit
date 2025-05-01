open class LSLabel: UILabel, LSViewInterfaceInternal {
    var lsTextColor: LabelTextColor?
    
    // MARK: - LSViewInterfaceInternal
    public var hitTestBehaviour: HitTestBehaviour?
    var lsCornerRadius: CornerRadiusApplier?
    var lsBackgroundColor: BackgroundColorApplier?
    var lsBorder: BorderApplier?
    var lsShadow: ShadowApplier?
    var lsLayerMask: LayerMaskApplier?
    
    open override var text: String? {
        didSet {
            lsLayerMask?.apply(to: self)
        }
    }
    
    // MARK: - Overrides
    open override func hitTest(_ point: CGPoint,
                               with event: UIEvent?) -> UIView? {
        guard let decorator = hitTestBehaviour else {
            return super.hitTest(point, with: event)
        }
        return decorator.hitTest(point, with: event)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        lsCornerRadius?.apply(to: self)
        lsShadow?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        lsBackgroundColor?.apply(to: self)
        lsBorder?.apply(to: self)
        lsShadow?.apply(to: self)
        lsTextColor?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
}

extension LSLabel: LSLabelInterface {
    public func useTextColor(_ textColor: ColorMap) {
        lsTextColor = LabelTextColor(textColor: textColor)
        lsTextColor?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    public func useNumberOfLines(_ numberOfLines: NumberOfLines) {
        self.numberOfLines = numberOfLines.value
    }
}
