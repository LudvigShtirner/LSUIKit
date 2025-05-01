struct LSViewAlphaAnimator {
    // MARK: - Data
    private let view: UIView
    private let alpha: CGFloat
    private let completion: BoolBlock?
    
    // MARK: - Life cycle
    init(view: UIView,
         alpha: CGFloat,
         completion: BoolBlock?) {
        self.view = view
        self.alpha = alpha
        self.completion = completion
    }
}

// MARK: - LSAnimator
extension LSViewAlphaAnimator: LSAnimator {
    func alreadyAtFinishState() -> Bool {
        view.alpha.isAlmostEqual(to: alpha)
    }
    
    func preaction() { }
    
    func runAnimation() {
        view.alpha = alpha
    }
    
    func completeAnimation(duration: TimeInterval,
                           success: Bool) {
        completion?(success)
    }
}
