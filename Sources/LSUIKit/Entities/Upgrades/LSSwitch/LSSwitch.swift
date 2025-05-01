open class LSSwitch: UISwitch, EventListenerInternal {
    // MARK: - LSSwitchInterface
    var onColor: SwitchOnColor?
    
    // MARK: - LSViewInterface
    public var hitTestBehaviour: HitTestBehaviour?
    var lsCornerRadius: CornerRadiusApplier?
    var lsBackgroundColor: BackgroundColorApplier?
    var lsBorder: BorderApplier?
    var lsShadow: ShadowApplier?
    
    // MARK: - Data
    var listeners: [String: UIControlListener] = [:]
    
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
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColors()
        lsBackgroundColor?.apply(to: self)
        lsBorder?.apply(to: self)
        lsShadow?.apply(to: self)
        onColor?.apply(to: self)
    }
    
    // MARK: - Internal methods
    open func setupUI() {}
    open func setupColors() {}
    open func setupConstraints() {}
}

// MARK: - LSSwitchInterface

extension LSSwitch: LSSwitchInterface {
    public func useIsOnColor(_ onColor: ColorMap) {
        self.onColor = SwitchOnColor(onColor: onColor)
        self.onColor?.apply(to: self)
    }
}
