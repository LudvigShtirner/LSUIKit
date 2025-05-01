protocol EventListenerInternal: EventListener {
    var listeners: [String: UIControlListener] { get set }
}

extension EventListenerInternal {
    @discardableResult
    public func onEvent(_ action: UIControl.Event,
                        _ closure: @escaping MainActorVoidBlock) -> Self {
        let listener = UIControlListener(
            control: self,
            event: action,
            action: closure
        )
        listeners[listener.key] = listener
        return self
    }
    
    // MARK: - Public methods
    @discardableResult
    public func onEvents(_ actions: [UIControl.Event],
                         _ closure: @escaping MainActorVoidBlock) -> Self {
        actions.forEach { action in
            onEvent(action, closure)
        }
        return self
    }
}
