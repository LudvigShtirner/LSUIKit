@MainActor
protocol GestureHandlerInternal: GestureHandler {
    var delegate: GestureRecognizerDelegate<GestureType> { get }
}

extension GestureHandlerInternal {
    @discardableResult
    public func onShouldBeginAction(_ closure: @escaping @MainActor (GestureType) -> Bool) -> Self {
        delegate.shouldBeginAction = closure
        gestureRecognizer.delegate = delegate
        return self
    }
    
    @discardableResult
    public func onShouldRecognizeSimultaneously(_ closure: @escaping @MainActor (GestureType, UIGestureRecognizer) -> Bool) -> Self {
        delegate.shouldRecognizeSimultaneously = closure
        gestureRecognizer.delegate = delegate
        return self
    }
    
    @discardableResult
    public func onShouldRequireFailure(_ closure: @escaping @MainActor (GestureType, UIGestureRecognizer) -> Bool) -> Self {
        delegate.shouldRequireFailure = closure
        gestureRecognizer.delegate = delegate
        return self
    }
    
    @discardableResult
    public func onShouldBeRequiredToFail(_ closure: @escaping @MainActor (GestureType, UIGestureRecognizer) -> Bool) -> Self {
        delegate.shouldBeRequiredToFail = closure
        gestureRecognizer.delegate = delegate
        return self
    }
    
    @discardableResult
    public func onShouldReceiveTouch(_ closure: @escaping @MainActor (GestureType, UITouch) -> Bool) -> Self {
        delegate.shouldReceiveTouch = closure
        gestureRecognizer.delegate = delegate
        return self
    }
    
    @discardableResult
    public func onShouldReceivePress(_ closure: @escaping @MainActor (GestureType, UIPress) -> Bool) -> Self {
        delegate.shouldReceivePress = closure
        gestureRecognizer.delegate = delegate
        return self
    }
    
    @discardableResult
    public func onShouldReceiveEvent(_ closure: @escaping @MainActor (GestureType, UIEvent) -> Bool) -> Self {
        delegate.shouldReceiveEvent = closure
        gestureRecognizer.delegate = delegate
        return self
    }
}
