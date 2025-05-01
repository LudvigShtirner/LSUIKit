@MainActor
public final class LongTapGestureHandler: GestureHandlerInternal {
    // MARK: - Dependencies
    lazy var delegate = GestureRecognizerDelegate<GestureType>()
    
    // MARK: - Data
    private var longTapGR: UILongPressGestureRecognizer!
    private var beganAction: GestureBlock?
    private var changedAction: GestureBlock?
    private var endedAction: GestureBlock?
    private var failedAction: GestureBlock?
    private var cancelledAction: GestureBlock?
    
    // MARK: - Inits
    public init(delegate: UIGestureRecognizerDelegate? = nil) {
        longTapGR = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongTap(_:))
        )
        longTapGR.delegate = delegate
        longTapGR.allowableMovement = 5.0
        longTapGR.minimumPressDuration = 0.2
        longTapGR.delaysTouchesEnded = false
    }
    
    // MARK: - GestureHandler
    public typealias GestureType = UILongPressGestureRecognizer
    
    public var gestureRecognizer: GestureType { longTapGR }
    
    @discardableResult
    public func onStart(_ closure: @escaping GestureBlock) -> Self {
        beganAction = closure
        return self
    }
    
    @discardableResult
    public func onChange(_ closure: @escaping GestureBlock) -> Self {
        changedAction = closure
        return self
    }
    
    @discardableResult
    public func onEnd(_ closure: @escaping GestureBlock) -> Self {
        endedAction = closure
        return self
    }
    
    @discardableResult
    public func onFail(_ closure: @escaping GestureBlock) -> Self {
        failedAction = closure
        return self
    }
    
    @discardableResult
    public func onCancel(_ closure: @escaping GestureBlock) -> Self {
        cancelledAction = closure
        return self
    }
    
    // MARK: - Actions
    @objc
    private func handleLongTap(_ longTap: UILongPressGestureRecognizer) {
        switch longTap.state {
        case .began:
            beganAction?(longTap)
        case .changed:
            changedAction?(longTap)
        case .ended:
            endedAction?(longTap)
        case .cancelled:
            cancelledAction?(longTap)
        case .failed:
            failedAction?(longTap)
        default: break
        }
    }
}
