@MainActor
public final class LSComposedAnimation {
    // MARK: - Data
    private var animations: [LSAnimation]
    
    // MARK: - Inits
    public init(first animation: LSAnimation,
                second animation2: LSAnimation) {
        animations = [animation, animation2]
    }
    
    // MARK: - Interface methods
    public func executeAtSameTime(duration: TimeInterval = 0.3,
                                  delay: TimeInterval = .zero,
                                  options: UIView.AnimationOptions = []) {
        let canStartAnimators = animations.compactMap {
            $0.animator.alreadyAtFinishState() ? nil : $0.animator
        }
        if canStartAnimators.isEmpty {
            return
        }
        canStartAnimators.forEach { $0.preaction() }
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options) {
            canStartAnimators.forEach { $0.runAnimation() }
        } completion: { success in
            canStartAnimators.forEach { $0.completeAnimation(duration: duration, success: success) }
        }
    }
    
    public func compose(with animation: LSAnimation) -> LSComposedAnimation {
        animations.append(animation)
        return self
    }
}
