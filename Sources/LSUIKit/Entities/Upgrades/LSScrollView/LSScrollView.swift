open class LSScrollView: UIScrollView {
    // MARK: - Dependencies
    private let multiDelegate = BaseScrollViewDelegate()
    
    // MARK: - Data
    open override var delegate: UIScrollViewDelegate? {
        get { multiDelegate }
        set {
            guard let newValue else { return }
            if newValue === multiDelegate { return }
            addDelegate(newValue)
        }
    }
    
    // MARK: - Life cycle
    public init() {
        super.init(frame: .zero)
        delegate = multiDelegate
        setupUI()
        setupColors()
        setupConstraints()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Overrides
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColors()
    }
    
    // MARK: - Internal methods to override
    open func setupUI() {}
    open func setupColors() {}
    open func setupConstraints() {}
    
    // MARK: - Interface methods
    public func addDelegate(_ delegate: UIScrollViewDelegate) {
        multiDelegate.addDelegate(delegate)
    }
    
    public func removeDelegate(_ delegate: UIScrollViewDelegate) {
        multiDelegate.removeDelegate(delegate)
    }
}

private final class BaseScrollViewDelegate: NSObject {
    // MARK: - Data
    private var delegates = NSHashTable<UIScrollViewDelegate>.weakObjects()
    
    // MARK: - Interface methods
    func addDelegate(_ delegate: UIScrollViewDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: UIScrollViewDelegate) {
        delegates.remove(delegate)
    }
}

extension BaseScrollViewDelegate: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegates.allObjects.forEach {
            $0.scrollViewDidScroll?(scrollView)
        }
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegates.allObjects.forEach {
            $0.scrollViewDidZoom?(scrollView)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegates.allObjects.forEach {
            $0.scrollViewWillBeginDragging?(scrollView)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegates.allObjects.forEach {
            $0.scrollViewWillEndDragging?(scrollView,
                                          withVelocity: velocity,
                                          targetContentOffset: targetContentOffset)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        delegates.allObjects.forEach {
            $0.scrollViewDidEndDragging?(scrollView,
                                         willDecelerate: decelerate)
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegates.allObjects.forEach {
            $0.scrollViewWillBeginDecelerating?(scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegates.allObjects.forEach {
            $0.scrollViewDidEndDecelerating?(scrollView)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegates.allObjects.forEach {
            $0.scrollViewDidEndScrollingAnimation?(scrollView)
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        delegates.allObjects.compactMap {
            $0.viewForZooming?(in: scrollView)
        }
        .first
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView,
                                    with view: UIView?) {
        delegates.allObjects.forEach {
            $0.scrollViewWillBeginZooming?(scrollView,
                                           with: view)
        }
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView,
                                 with view: UIView?,
                                 atScale scale: CGFloat) {
        delegates.allObjects.forEach {
            $0.scrollViewDidEndZooming?(scrollView,
                                        with: view,
                                        atScale: scale)
        }
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        delegates.allObjects.compactMap {
            $0.scrollViewShouldScrollToTop?(scrollView)
        }
        .first ?? false
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegates.allObjects.forEach {
            $0.scrollViewDidScrollToTop?(scrollView)
        }
    }

    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        delegates.allObjects.forEach {
            $0.scrollViewDidChangeAdjustedContentInset?(scrollView)
        }
    }
}
