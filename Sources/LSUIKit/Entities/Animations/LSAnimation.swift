@MainActor
public struct LSAnimation {
    // MARK: - Data
    let animator: LSAnimator
    
    // MARK: - Inits
    init(animator: LSAnimator) {
        self.animator = animator
    }
    
    // MARK: - Interface methods
    public func execute(duration: TimeInterval = 0.3,
                        delay: TimeInterval = .zero,
                        options: UIView.AnimationOptions = []) {
        if animator.alreadyAtFinishState() {
            return
        }
        animator.preaction()
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options) {
            self.animator.runAnimation()
        } completion: { success in
            self.animator.completeAnimation(duration: duration,
                                            success: success)
        }
    }
    
    public func compose(with another: LSAnimation) -> LSComposedAnimation {
        LSComposedAnimation(first: self,
                            second: another)
    }
}
