struct LSViewShakeAnimator {
    // MARK: - Data
    private let view: UIView
    private let shakeSteps: [ShakeStep]
    private let completion: BoolBlock?
    
    // MARK: - Inits
    init(view: UIView,
         shakeSteps: [ShakeStep],
         completion: BoolBlock?) {
        self.view = view
        self.shakeSteps = shakeSteps
        self.completion = completion
    }
}

// MARK: - LSAnimator
extension LSViewShakeAnimator: LSKeyFrameAnimator {
    var key: String { "position.x" }
    func alreadyAtFinishState() -> Bool { false }
    
    func preaction() {
        view.layer.removeAnimation(forKey: key)
    }
    
    func runAnimation(_ animation: CAKeyframeAnimation) {
        animation.values = shakeSteps.map(\.value)
        animation.keyTimes = shakeSteps.map { NSNumber(floatLiteral: $0.keyTime) }
        view.layer.add(animation, forKey: key)
    }
    
    func completeAnimation(success: Bool) {
        completion?(success)
    }
}

public struct ShakeStep {
    // MARK: - Data
    let value: CGFloat
    let keyTime: TimeInterval
    
    // MARK: - Inits
    public init(value: CGFloat,
                keyTime: TimeInterval) {
        self.value = value
        self.keyTime = keyTime.inRange(min: .zero, max: 1.0)
    }
}

// MARK: - SwiftUI Preview
import SwiftUI
import SnapKit

struct LSViewShakeAnimatorPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            let button = LSButton().apply {
                $0.useTitle(normalText: "Shake")
                $0.useTitleColor(.init(normal: .init(color: .white)))
                $0.useBackgroundColors(.init(normal: .init(color: UIColor.magenta)))
                $0.useFont(UIFont.systemFont(ofSize: 24, weight: .bold))
                $0.useCornerRadius(.circled)
                $0.clipsToBounds = true
            }
                
            button.onEvent(.touchUpInside) { [weak button] in
                button?.ls.animation.shake(shakeSteps: [
                    ShakeStep(value: -7, keyTime: 0.2),
                    ShakeStep(value: 7, keyTime: 0.4),
                    ShakeStep(value: -3, keyTime: 0.6),
                    ShakeStep(value: 3, keyTime: 0.8),
                ], completion: { [weak button] finished in
                    let color = finished ? UIColor.blue : UIColor.red
                    button?.useBackgroundColors(.init(normal: .init(color: color)))
                })
                .execute()
            }
            
            return LSCenteredContainer(
                content: button,
                width: .fixed(240),
                height: .fixed(64)
            )
        }
        .previewLayout(.fixed(width: 375, height: 44))
        .edgesIgnoringSafeArea(.vertical)
    }
}
