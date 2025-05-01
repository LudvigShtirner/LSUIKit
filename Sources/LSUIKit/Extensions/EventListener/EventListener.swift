public protocol EventListener: UIControl {
    @discardableResult
    func onEvent(_ action: UIControl.Event,
                 _ closure: @escaping MainActorVoidBlock) -> Self
    
    @discardableResult
    func onEvents(_ actions: [UIControl.Event],
                  _ closure: @escaping MainActorVoidBlock) -> Self
}
