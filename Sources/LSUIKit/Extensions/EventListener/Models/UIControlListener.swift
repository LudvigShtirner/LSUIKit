@MainActor
final class UIControlListener {
    // MARK: - Data
    private let event: UIControl.Event
    private let action: MainActorVoidBlock
    let key: String
    
    // MARK: - Inits
    init(control: UIControl,
         event: UIControl.Event,
         action: @escaping MainActorVoidBlock) {
        self.event = event
        self.action = action
        self.key = String(describing: event)
        
        control.addTarget(self,
                          action: #selector(handle),
                          for: event)
    }
    
    @objc private func handle() {
        action()
    }
}

