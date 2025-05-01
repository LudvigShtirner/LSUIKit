@MainActor
public final class LSKeyFrameAnimation: NSObject {
    // MARK: - Data
    let animator: LSKeyFrameAnimator
    
    // MARK: - Inits
    init(animator: LSKeyFrameAnimator) {
        self.animator = animator
    }
    
    // MARK: - Interface methods
    public func execute(duration: TimeInterval = 0.3,
                        delay: TimeInterval = .zero) {
        if animator.alreadyAtFinishState() {
            return
        }
        animator.preaction()
        
        let animation = CAKeyframeAnimation(keyPath: animator.key)
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.animator.runAnimation(animation)
        }
    }
}

extension LSKeyFrameAnimation: CAAnimationDelegate {
    nonisolated public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        Task { @MainActor in
            self.animator.completeAnimation(success: flag)
        }
    }
}
