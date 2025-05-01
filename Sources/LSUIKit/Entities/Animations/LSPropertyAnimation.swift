@MainActor
public struct LSPropertyAnimationFrame {
    private let view: UIView
    private let initialFrame: CGRect
    private let resultFrame: CGRect
    private let duration: TimeInterval
    private let completion: (UIViewAnimatingPosition) -> Void
    
    public init(view: UIView, 
                initialFrame: CGRect, 
                resultFrame: CGRect,
                duration: TimeInterval,
                completion: @escaping (UIViewAnimatingPosition) -> Void) {
        self.view = view
        self.initialFrame = initialFrame
        self.resultFrame = resultFrame
        self.duration = duration
        self.completion = completion
    }
    
    public func execute() -> LSPropertyAnimationFrameRunning {
        let animator = UIViewPropertyAnimator(duration: duration,
                                              curve: .linear)
        animator.addAnimations {
            view.frame = resultFrame
        }
        animator.addCompletion(completion)
        animator.startAnimation()
        return LSPropertyAnimationFrameRunning(animator: animator)
    }
}

@MainActor
public struct LSPropertyAnimationFrameRunning {
    private let animator: UIViewPropertyAnimator

    public init(animator: UIViewPropertyAnimator) {
        self.animator = animator
    }

    public func pause() {
        animator.stopAnimation(false)
    }

    public func cancel() {
        animator.stopAnimation(true)
    }
}
