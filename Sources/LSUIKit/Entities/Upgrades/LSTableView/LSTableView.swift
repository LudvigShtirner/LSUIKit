public final class LSTableView<
    EmptyView: UIView,
    LoadingView: UIView
>: UITableView, LSViewInterfaceInternal {
    // MARK: - LSViewInterfaceInternal
    public var hitTestBehaviour: HitTestBehaviour?
    var lsBackgroundColor: BackgroundColorApplier?
    var lsBorder: BorderApplier?
    var lsCornerRadius: CornerRadiusApplier?
    var lsShadow: ShadowApplier?
    var lsLayerMask: LayerMaskApplier?
    
    // MARK: - Dependencies
    private lazy var dataProvider = LSTableViewDataSource(tableView: self)
    
    // MARK: - UI
    public let emptyView: EmptyView
    public let loadingView: LoadingView
    
    // MARK: - Data
    public internal(set) var isLoading = false {
        didSet {
            loadingView.isHidden = !isLoading
        }
    }
    
    public internal(set) var isEmpty = true {
        didSet {
            emptyView.isHidden = !isEmpty
        }
    }
    
    // MARK: - Inits
    public init(
        frame: CGRect,
        style: UITableView.Style,
        emptyView: EmptyView,
        loadingView: LoadingView
    ) {
        self.emptyView = emptyView
        self.loadingView = loadingView
        super.init(frame: frame, style: style)
        emptyView.isHidden = !isEmpty
        setupUI()
        setupConstraints()
    }
    
    convenience public init(
        emptyView: EmptyView,
        loadingView: LoadingView
    ) {
        self.init(
            frame: .zero,
            style: .plain,
            emptyView: emptyView,
            loadingView: loadingView
        )
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        lsBackgroundColor?.apply(to: self)
        lsBorder?.apply(to: self)
        lsShadow?.apply(to: self)
        lsLayerMask?.apply(to: self)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
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
}

// MARK: - Interface methods
public extension LSTableView {
    func reload(
        snapshot: LSTableDataSnapshot,
        animated: Bool,
        completion: SendableVoidBlock?
    ) {
        dataProvider.reload(
            snapshot: snapshot,
            animated: animated,
            completion: { [weak self] in
                self?.isLoading = false
                self?.isEmpty = snapshot.isEmpty
                completion?()
            }
        )
    }
}

// MARK: - Private methods
private extension LSTableView {
    func setupUI() {
        addSubview(emptyView)
        addSubview(loadingView)
    }
    
    func setupConstraints() {
        emptyView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        loadingView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}
