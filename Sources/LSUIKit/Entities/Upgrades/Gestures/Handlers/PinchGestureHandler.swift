@MainActor
public final class PinchGestureHandler: GestureHandlerInternal {
    // MARK: - Dependencies
    lazy var delegate = GestureRecognizerDelegate<GestureType>()
    
    // MARK: - Data
    private var pinchGR: UIPinchGestureRecognizer!
    private var beganAction: GestureBlock?
    private var changedAction: GestureBlock?
    private var endedAction: GestureBlock?
    private var failedAction: GestureBlock?
    private var cancelledAction: GestureBlock?
    
    public var handleFailAndCancelWithEnd = false
    
    // MARK: - Inits
    public init() {
        pinchGR = UIPinchGestureRecognizer(
            target: self,
            action: #selector(handlePinch(_:))
        )
    }
    
    // MARK: - GestureHandler
    public typealias GestureType = UIPinchGestureRecognizer
    
    public var gestureRecognizer: GestureType { pinchGR }
    
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
    private func handlePinch(_ pinch: UIPinchGestureRecognizer) {
        switch pinch.state {
        case .began:
            beganAction?(pinch)
        case .changed:
            changedAction?(pinch)
        case .ended:
            endedAction?(pinch)
        case .cancelled:
            if handleFailAndCancelWithEnd {
                endedAction?(pinch)
                return
            }
            cancelledAction?(pinch)
        case .failed:
            if handleFailAndCancelWithEnd {
                endedAction?(pinch)
                return
            }
            failedAction?(pinch)
        default: break
        }
    }
}
