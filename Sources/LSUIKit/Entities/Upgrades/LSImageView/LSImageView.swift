open class LSImageView: UIImageView, LSViewInterfaceInternal, LSImageViewInterface {
    // MARK: - LSImageViewInterface
    var lsTintColor: ImageViewTintColor?
    
    // MARK: - LSViewInterfaceInternal
    public var hitTestBehaviour: HitTestBehaviour?
    var lsCornerRadius: CornerRadiusApplier?
    var lsBackgroundColor: BackgroundColorApplier?
    var lsBorder: BorderApplier?
    var lsShadow: ShadowApplier?
    var lsLayerMask: LayerMaskApplier?
    
    // MARK: - Overrides
    open override func hitTest(_ point: CGPoint,
                               with event: UIEvent?) -> UIView? {
        guard let decorator = hitTestBehaviour else {
            return super.hitTest(point, with: event)
        }
        return decorator.hitTest(point, with: event)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        lsCornerRadius?.apply(to: self)
        lsShadow?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        lsBackgroundColor?.apply(to: self)
        lsBorder?.apply(to: self)
        lsShadow?.apply(to: self)
        lsTintColor?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    // MARK: - LSImageViewInterface
    public func useTintColor(_ tintColor: ColorMap) {
        lsTintColor = ImageViewTintColor(tintColor: tintColor)
        lsTintColor?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    public func useImage(_ image: UIImage?) {
        guard let image else {
            self.image = nil
            return
        }
        Task { @MainActor in
            self.image = await image.byPreparingForDisplay()
            self.lsLayerMask?.apply(to: self)
        }
    }
    
    public func useHighlightedImage(_ highlightedImage: UIImage?) {
        guard let highlightedImage else {
            self.highlightedImage = nil
            return
        }
        Task { @MainActor in
            self.image = await highlightedImage.byPreparingForDisplay()
            self.lsLayerMask?.apply(to: self)
        }
    }
}
