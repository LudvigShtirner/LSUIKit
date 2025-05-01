@MainActor
public final class ScreenEdgePanGestureHandler: GestureHandlerInternal {
    // MARK: - Dependencies
    lazy var delegate = GestureRecognizerDelegate<GestureType>()
    
    // MARK: - Data
    private var screenEdgeGR: UIScreenEdgePanGestureRecognizer!
    private var beganAction: GestureBlock?
    private var changedAction: GestureBlock?
    private var endedAction: GestureBlock?
    private var failedAction: GestureBlock?
    private var cancelledAction: GestureBlock?
    
    public var handleFailAndCancelWithEnd = false
    
    // MARK: - Inits
    public init(edges: UIRectEdge) {
        screenEdgeGR = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:))
        )
        screenEdgeGR.edges = edges
    }
    
    // MARK: - GestureHandler
    public typealias GestureType = UIScreenEdgePanGestureRecognizer
    
    public var gestureRecognizer: GestureType { screenEdgeGR }
    
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
    private func handlePan(_ pan: UIScreenEdgePanGestureRecognizer) {
        switch pan.state {
        case .began:
            beganAction?(pan)
        case .changed:
            changedAction?(pan)
        case .ended:
            endedAction?(pan)
        case .cancelled:
            if handleFailAndCancelWithEnd {
                endedAction?(pan)
                return
            }
            cancelledAction?(pan)
        case .failed:
            if handleFailAndCancelWithEnd {
                endedAction?(pan)
                return
            }
            failedAction?(pan)
        default: break
        }
    }
}
