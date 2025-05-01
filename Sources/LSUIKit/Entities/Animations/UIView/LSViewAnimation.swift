@MainActor
public struct LSViewAnimation {
    // MARK: - Data
    private let view: UIView
    
    // MARK: - Inits
    init(view: UIView) {
        self.view = view
    }
    
    // MARK: - Interface methods
    public func changeVisibility(config: HideAnimatorConfiguration,
                                 completion: BoolBlock? = nil) -> LSAnimation {
        let animator = LSViewHideAnimator(view: view,
                                          config: config,
                                          completion: completion)
        return LSAnimation(animator: animator)
    }
    
    public func hide(completion: BoolBlock? = nil) -> LSAnimation {
        changeVisibility(config: .hide,
                         completion: completion)
    }
    
    public func show(alpha: CGFloat = 1.0,
                     completion: BoolBlock? = nil) -> LSAnimation {
        changeVisibility(config: .show(alpha),
                         completion: completion)
    }
    
    public func transform(transform: CGAffineTransform,
                          completion: BoolBlock? = nil) -> LSAnimation {
        let animator = LSViewTransformAnimator(view: view,
                                               transform: transform,
                                               completion: completion)
        return LSAnimation(animator: animator)
    }
    
    public func alpha(alpha: CGFloat,
                      completion: BoolBlock? = nil) -> LSAnimation {
        let animator = LSViewAlphaAnimator(view: view,
                                           alpha: alpha,
                                           completion: completion)
        return LSAnimation(animator: animator)
    }
    
    public func constraints(constraintsSetAction: @escaping VoidBlock,
                            completion: BoolBlock? = nil) -> LSAnimation {
        let animator = LSViewConstraintsAnimator(view: view,
                                                 constraintsSetAction: constraintsSetAction,
                                                 completion: completion)
        return LSAnimation(animator: animator)
    }
    
    public func shake(shakeSteps: [ShakeStep],
                      completion: BoolBlock? = nil) -> LSKeyFrameAnimation {
        var updatedSteps = shakeSteps
            .reduce([TimeInterval: CGFloat](), { partialResult, step in
                var map = partialResult
                map[step.keyTime] = step.value
                return map
            })
        if updatedSteps.contains(where: { $0.key == .zero}) == false {
            updatedSteps[.zero] = .zero
        }
        if updatedSteps.contains(where: { $0.key == 1}) == false {
            updatedSteps[1] = .zero
        }
        let steps = updatedSteps
            .map { ShakeStep(value: $0.value, keyTime: $0.key)}
            .sorted(by: \.keyTime)
        let animator = LSViewShakeAnimator(view: view,
                                           shakeSteps: steps,
                                           completion: completion)
        return LSKeyFrameAnimation(animator: animator)
    }
}
