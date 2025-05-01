open class LSButton: UIButton, EventListenerInternal, LSViewInterfaceInternalCommon {
    // MARK: - LSButtonInterface
    var lsTintColor: ButtonTintColorApplier?
    var lsTitleColor: TitleColorApplier?
    var lsBackgroundColors: BackgroundColorsApplier?
    var lsBorders: BordersApplier?
    
    // MARK: - LSViewInterfaceInternalCommon
    public var hitTestBehaviour: HitTestBehaviour?
    var lsCornerRadius: CornerRadiusApplier?
    var lsShadow: ShadowApplier?
    var lsLayerMask: LayerMaskApplier?
    
    // MARK: - Data
    var listeners: [String: UIControlListener] = [:]
    
    // MARK: - Inits
    public convenience init() {
        self.init(frame: .zero)
    }
    
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
            guard isHighlighted != oldValue else { return }
            lsTitleColor?.apply(to: self)
            lsBackgroundColors?.apply(to: self)
            lsBorders?.apply(to: self)
            lsLayerMask?.apply(to: self)
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            lsTitleColor?.apply(to: self)
            lsBackgroundColors?.apply(to: self)
            lsBorders?.apply(to: self)
            lsLayerMask?.apply(to: self)
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            lsLayerMask?.apply(to: self)
            setNeedsDisplay()
        }
    }
    
    public override func setTitle(_ title: String?,
                                  for state: UIControl.State) {
        super.setTitle(title, for: state)
        setNeedsDisplay()
    }
    
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
        setupColors()
        lsBackgroundColors?.apply(to: self)
        lsShadow?.apply(to: self)
        lsTintColor?.apply(to: self)
        lsTitleColor?.apply(to: self)
        lsBorders?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    // MARK: - Internal methods
    open func setupUI() {}
    open func setupColors() {}
    open func setupConstraints() {}
}

extension LSButton: LSButtonInterface {
    public func useTintColor(_ tintColor: ColorMap) {
        lsTintColor = ButtonTintColorApplier(colorMap: tintColor)
        lsTintColor?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    public func useTitleColor(_ titleColor: ColorSet) {
        lsTitleColor = TitleColorApplier(titleColorSet: titleColor)
        lsTitleColor?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    public func useBackgroundColors(_ backgroundColors: ColorSet) {
        lsBackgroundColors = BackgroundColorsApplier(colorSet: backgroundColors)
        lsBackgroundColors?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    public func useImageSet(_ imageSet: ImageSet) {
        setImage(imageSet.normalImage, for: .normal)
        setImage(imageSet.highlightImage, for: .highlighted)
        setImage(imageSet.disabledImage, for: .disabled)
        lsLayerMask?.apply(to: self)
    }
    
    public func useBackgroundImageSet(_ imageSet: ImageSet) {
        setBackgroundImage(imageSet.normalImage, for: .normal)
        setBackgroundImage(imageSet.highlightImage, for: .highlighted)
        setBackgroundImage(imageSet.disabledImage, for: .disabled)
        lsLayerMask?.apply(to: self)
    }
    
    public func useTitle(normalText: String,
                         highlightText: String? = nil,
                         disabledText: String? = nil) {
        setTitle(normalText, for: .normal)
        setTitle(highlightText, for: .highlighted)
        setTitle(disabledText, for: .disabled)
        lsLayerMask?.apply(to: self)
    }
    
    public func useFont(_ font: UIFont) {
        if titleLabel == nil {
            setTitle("", for: .normal)
        }
        titleLabel?.font = font
        lsLayerMask?.apply(to: self)
    }
    
    public func useNumberOfLines(_ numberOfLines: NumberOfLines) {
        titleLabel?.numberOfLines = numberOfLines.value
        lsLayerMask?.apply(to: self)
    }
    
    public func useBorders(_ borders: Borders) {
        lsBorders = BordersApplier(borders: borders)
        lsBorders?.apply(to: self)
    }
}
