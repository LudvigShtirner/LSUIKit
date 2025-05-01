struct LSViewTransformAnimator {
    // MARK: - Data
    private let view: UIView
    private let transform: CGAffineTransform
    private let completion: BoolBlock?
    
    // MARK: - Inits
    init(view: UIView,
         transform: CGAffineTransform,
         completion: BoolBlock?) {
        self.view = view
        self.transform = transform
        self.completion = completion
    }
}

// MARK: - LSAnimator
extension LSViewTransformAnimator: LSAnimator {
    func alreadyAtFinishState() -> Bool {
        view.transform == transform
    }
    
    func preaction() { }
    
    func runAnimation() {
        view.transform = transform
    }
    
    func completeAnimation(duration: TimeInterval,
                           success: Bool) {
        completion?(success)
    }
}
