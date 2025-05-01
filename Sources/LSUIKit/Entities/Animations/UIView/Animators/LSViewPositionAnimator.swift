struct LSViewPositionAnimator {
    // MARK: - Data
    private let view: UIView
    private let offset: CGPoint
    private let completion: BoolBlock?
    
    // MARK: - Inits
    init(view: UIView,
         offset: CGPoint,
         completion: BoolBlock?) {
        self.view = view
        self.offset = offset
        self.completion = completion
    }
}

// MARK: - LSAnimator
extension LSViewPositionAnimator: LSAnimator {
    func alreadyAtFinishState() -> Bool {
        offset.isAlmostEqual(to: .zero)
    }
    
    func preaction() { }
    
    func runAnimation() {
        view.frame.origin = CGPoint(x: view.frame.origin.x - offset.x,
                                    y: view.frame.origin.y - offset.y)
    }
    
    func completeAnimation(duration: TimeInterval,
                           success: Bool) {
        completion?(success)
    }
}
