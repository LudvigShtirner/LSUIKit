open class LSSlider: UISlider, EventListenerInternal, LSViewInterfaceInternal {
    // MARK: - LSSliderInterface
    public var sliderDrawer: LSSliderDrawer?
    public var trackingEventHandler: LSSliderTrackingEventHandler?
    public var layoutSubviewsDecorator: LSSliderLayoutSubviewsDecorator?
    public var thumbRectDecorator: LSSliderThumbRectDecorator?
    
    var thumbImages: LSSliderThumbImage?
    var thumbColors: LSSliderThumbColors?
    var minimumTrackColors: LSSliderMinimumTrackColor?
    var maximumTrackColors: LSSliderMaximumTrackColor?
    
    // MARK: - LSViewInterfaceInternal
    public var hitTestBehaviour: HitTestBehaviour?
    var lsCornerRadius: CornerRadiusApplier?
    var lsBackgroundColor: BackgroundColorApplier?
    var lsBorder: BorderApplier?
    var lsShadow: ShadowApplier?
    var lsLayerMask: LayerMaskApplier?
    
    // MARK: - Data
    var listeners: [String: UIControlListener] = [:]
    
    public var currentValue: CGFloat { CGFloat(value) }
    public var minimumCGValue: CGFloat { CGFloat(minimumValue) }
    public var maximumCGValue: CGFloat { CGFloat(maximumValue) }
    public var allValuesWide: CGFloat { maximumCGValue - minimumCGValue }
    public var averageValue: CGFloat { minimumCGValue + allValuesWide.half }
    
    public var leftImageOffset = CGFloat(10)
    public var rightImageOffset = CGFloat(10)
    public var leftOffset: CGFloat {
        guard let image = minimumValueImage else { return .zero }
        return image.size.width + leftImageOffset
    }
    public var rightOffset: CGFloat {
        guard let image = maximumValueImage else { return .zero }
        return image.size.width + rightImageOffset
    }
    public var sliderWidth: CGFloat { bounds.width - leftOffset - rightOffset }
    
    public var thumbCenterX: CGFloat {
        let trackFrame = trackRect(forBounds: bounds)
        let thumbFrame = thumbRect(forBounds: bounds,
                                   trackRect: trackFrame,
                                   value: value)
        return thumbFrame.origin.x + thumbFrame.width.half - trackFrame.origin.x
    }
    
    // MARK: - Inits
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupColors()
        setupConstraints()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupColors()
        setupConstraints()
    }
    
    deinit {
        listeners = [:]
    }
    
    // MARK: - Overrides
    open override var isHighlighted: Bool {
        didSet {
            minimumTrackColors?.apply(to: self)
            maximumTrackColors?.apply(to: self)
            thumbColors?.apply(to: self)
            lsLayerMask?.apply(to: self)
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            minimumTrackColors?.apply(to: self)
            maximumTrackColors?.apply(to: self)
            thumbColors?.apply(to: self)
            lsLayerMask?.apply(to: self)
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColors()
        minimumTrackColors?.apply(to: self)
        maximumTrackColors?.apply(to: self)
        lsBackgroundColor?.apply(to: self)
        lsBorder?.apply(to: self)
        lsShadow?.apply(to: self)
        thumbColors?.apply(to: self)
        thumbImages?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        lsCornerRadius?.apply(to: self)
        lsShadow?.apply(to: self)
        layoutSubviewsDecorator?.handleLayoutSubviews()
        lsLayerMask?.apply(to: self)
    }
    
    open override func hitTest(_ point: CGPoint,
                               with event: UIEvent?) -> UIView? {
        guard let decorator = hitTestBehaviour else {
            return super.hitTest(point, with: event)
        }
        return decorator.hitTest(point, with: event)
    }
    
    open override func draw(_ rect: CGRect) {
        guard let drawer = sliderDrawer,
              let context = UIGraphicsGetCurrentContext() else {
            super.draw(rect)
            return
        }
        _ = drawer.drawSlider(self,
                              rect: rect,
                              context: context)
    }
    
    open override func thumbRect(forBounds bounds: CGRect,
                                 trackRect rect: CGRect,
                                 value: Float) -> CGRect {
        let superAnswer = super.thumbRect(forBounds: bounds,
                                          trackRect: rect,
                                          value: value)
        guard let thumbRectDecorator else {
            return superAnswer
        }
        return thumbRectDecorator.thumbRect(forBounds: bounds,
                                            trackRect: rect,
                                            value: value,
                                            slider: self,
                                            superAnswer: superAnswer)
    }
    
    open override func beginTracking(_ touch: UITouch,
                                     with event: UIEvent?) -> Bool {
        guard let trackingEventHandler else {
            return super.beginTracking(touch, with: event)
        }
        trackingEventHandler.beginTracking(
            touch,
            with: event,
            on: self
        )
        continueTracking(touch, with: event)
        return true
    }
    
    open override func endTracking(_ touch: UITouch?, 
                                   with event: UIEvent?) {
        guard let trackingEventHandler else {
            return super.endTracking(touch, with: event)
        }
        trackingEventHandler.endTracking(
            touch,
            with: event,
            on: self
        )
    }
    
    // MARK: - Internal methods
    open func setupUI() {}
    open func setupColors() {}
    open func setupConstraints() {}
}

// MARK: - LSSliderInterface

extension LSSlider: LSSliderInterface {
    public func useThumbImage(_ thumbImage: ImageSet) {
        self.thumbImages = LSSliderThumbImage(thumbImage: thumbImage)
        self.thumbImages?.apply(to: self)
    }
    
    public func useThumbTintColor(_ thumbColors: ColorSet) {
        self.thumbColors = LSSliderThumbColors(thumbColors: thumbColors)
        self.thumbColors?.apply(to: self)
    }
    
    public func useMinimumTrackColors(_ minimumColors: ColorSet) {
        self.minimumTrackColors = LSSliderMinimumTrackColor(colorSet: minimumColors)
        self.minimumTrackColors?.apply(to: self)
    }
    
    public func useMaximumTrackColors(_ maximumColors: ColorSet) {
        self.maximumTrackColors = LSSliderMaximumTrackColor(colorSet: maximumColors)
        self.maximumTrackColors?.apply(to: self)
    }
}
