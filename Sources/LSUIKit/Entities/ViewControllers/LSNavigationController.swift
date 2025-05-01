open class LSNavigationController: UINavigationController {
    // MARK: - Dependencies
    private let __delegate = LSNavigationControllerDelegate()
    
    // MARK: - Data
    open override var delegate: (any UINavigationControllerDelegate)? {
        get { __delegate }
        set {
            guard let newValue else { return }
            if newValue === __delegate { return }
            addDelegate(newValue)
        }
    }
    
    // MARK: - Life cycle
    public override init(nibName nibNameOrNil: String?,
                         bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Overrides
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = __delegate
        setupUI()
        setupColors()
        setupConstraints()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColors()
    }
    
    // MARK: - Internal methods to override
    open func setupUI() {}
    open func setupColors() {}
    open func setupConstraints() {}
    
    // MARK: - Interface methods
    public func setBackGestureHandler(_ handler: UIGestureRecognizerDelegate) {
        interactivePopGestureRecognizer?.delegate = handler
    }
    
    public func addDelegate(_ delegate: UINavigationControllerDelegate) {
        __delegate.multiDelegate.addDelegate(delegate)
    }
    
    public func removeDelegate(_ delegate: UINavigationControllerDelegate) {
        __delegate.multiDelegate.removeDelegate(delegate)
    }
}

// MARK: - LSNavigationControllerDelegate

final class LSNavigationControllerDelegate: NSObject {
    let multiDelegate = MultiDelegate<UINavigationControllerDelegate>()
}

extension LSNavigationControllerDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        multiDelegate.call {
            $0.navigationController?(navigationController,
                                     willShow: viewController,
                                     animated: animated)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        multiDelegate.call {
            $0.navigationController?(navigationController,
                                     didShow: viewController,
                                     animated: animated)
        }
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        multiDelegate.call {
            $0.navigationControllerSupportedInterfaceOrientations?(navigationController)
        }
        .first ?? .portrait
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        multiDelegate.call {
            $0.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController)
        }
        .first ?? .portrait
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        multiDelegate.call {
            $0.navigationController?(navigationController,
                                     interactionControllerFor: animationController)
        }
        .first
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        multiDelegate.call {
            $0.navigationController?(navigationController,
                                     animationControllerFor: operation,
                                     from: fromVC,
                                     to: toVC)
        }
        .first
    }
}
