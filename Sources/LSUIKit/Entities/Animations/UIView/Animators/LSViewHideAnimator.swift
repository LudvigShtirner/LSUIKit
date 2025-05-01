struct LSViewHideAnimator {
    // MARK: - Data
    private let view: UIView
    private let config: HideAnimatorConfiguration
    private let completion: BoolBlock?
    
    // MARK: - Inits
    init(view: UIView,
         config: HideAnimatorConfiguration,
         completion: BoolBlock?) {
        self.view = view
        self.config = config
        self.completion = completion
    }
}

// MARK: - LSAnimator
extension LSViewHideAnimator: LSAnimator {
    func alreadyAtFinishState() -> Bool {
        view.isHidden == config.isHidden
    }
    
    func preaction() {
        view.isHidden = false
    }
    
    func runAnimation() {
        view.alpha = config.alpha
    }
    
    func completeAnimation(duration: TimeInterval,
                           success: Bool) {
        view.isHidden = config.isHidden
        view.alpha = config.alpha
        completion?(success)
    }
}

// MARK: - Subtypes
public enum HideAnimatorConfiguration {
    case hide
    case show(CGFloat)
    
    var isHidden: Bool {
        switch self {
        case .hide: return true
        case .show(let alpha): return alpha.isAlmostEqual(to: .zero)
        }
    }
    
    var alpha: CGFloat {
        switch self {
        case .hide: return .zero
        case .show(let alpha): return alpha
        }
    }
}
