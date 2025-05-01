@MainActor
public protocol GestureHandler: AnyObject {
    associatedtype GestureType: UIGestureRecognizer
    typealias GestureBlock = @MainActor (GestureType) -> Void
    
    var gestureRecognizer: GestureType { get }

    var isEnabled: Bool { get set }
    var isActive: Bool { get }
        
    @discardableResult
    func onStart(_ closure: @escaping GestureBlock) -> Self
    
    @discardableResult
    func onChange(_ closure: @escaping GestureBlock) -> Self
    
    @discardableResult
    func onEnd(_ closure: @escaping GestureBlock) -> Self
    
    @discardableResult
    func onFail(_ closure: @escaping GestureBlock) -> Self
    
    @discardableResult
    func onCancel(_ closure: @escaping GestureBlock) -> Self
    
    @discardableResult
    func onShouldBeginAction(_ closure: @escaping @MainActor (GestureType) -> Bool) -> Self
    
    @discardableResult
    func onShouldRecognizeSimultaneously(_ closure: @escaping @MainActor (GestureType, UIGestureRecognizer) -> Bool) -> Self
    
    @discardableResult
    func onShouldRequireFailure(_ closure: @escaping @MainActor (GestureType, UIGestureRecognizer) -> Bool) -> Self
    
    @discardableResult
    func onShouldBeRequiredToFail(_ closure: @escaping @MainActor (GestureType, UIGestureRecognizer) -> Bool) -> Self
    
    @discardableResult
    func onShouldReceiveTouch(_ closure: @escaping @MainActor (GestureType, UITouch) -> Bool) -> Self
    
    @discardableResult
    func onShouldReceivePress(_ closure: @escaping @MainActor (GestureType, UIPress) -> Bool) -> Self
    
    @discardableResult
    func onShouldReceiveEvent(_ closure: @escaping @MainActor (GestureType, UIEvent) -> Bool) -> Self
}

public extension GestureHandler {
    var isActive: Bool {
        return gestureRecognizer.state != .possible
    }
    
    var isEnabled: Bool {
        get { gestureRecognizer.isEnabled }
        set { gestureRecognizer.isEnabled = newValue }
    }
    
    @discardableResult
    func insert(into view: UIView) -> Self {
        view.addGestureRecognizer(gestureRecognizer)
        return self
    }
}
