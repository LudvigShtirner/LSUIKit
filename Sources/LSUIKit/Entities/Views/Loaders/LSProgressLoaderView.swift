@MainActor
public final class LSProgressLoaderView: LSView {
    // MARK: - Data
    private let progressTimer = ProgressTimer()
    
    // MARK: - Proxies
    private static let updateLayer: (LSProgressLoaderView, Any) -> Void = { (instance, _) in instance.progressLayer!.setNeedsDisplay() }
    
    @ProxyWithAction(\.progressLayer.trackTintColor,
                      extraAction: LSProgressLoaderView.updateLayer)
    public var trackTintColor: UIColor
    
    @ProxyWithAction(\.progressLayer.progressTintColor,
                      extraAction: LSProgressLoaderView.updateLayer)
    public var progressTintColor: UIColor
    
    @ProxyWithAction(\.progressLayer.innerTintColor,
                      extraAction: LSProgressLoaderView.updateLayer)
    public var innerTintColor: UIColor?
    
    @ProxyWithAction(\.progressLayer.roundedCorners, 
                      extraAction: LSProgressLoaderView.updateLayer)
    public var roundedCorners: Bool
    
    @ProxyWithAction(\.progressLayer.thicknessRatio,
                      extraAction: LSProgressLoaderView.updateLayer)
    public var thicknessRatio: CGFloat
    
    @ProxyWithAction(\.progressLayer.clockwise, 
                      extraAction: LSProgressLoaderView.updateLayer)
    public var clockwise: Bool
    
    public var progress: CGFloat { progressLayer.progress }
    
    var isAnimating: Bool {
        progressLayer.animation(forKey: AnimationKeys.progress) != nil
    }
    
    // MARK: - Life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    // MARK: - Overrides
    private var progressLayer: LSProgressLayer! { layer as? LSProgressLayer }
    public override class var layerClass: AnyClass { LSProgressLayer.self }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard let window else { return }
        progressLayer.contentsScale = window.screen.scale
        progressLayer.setNeedsDisplay()
    }
    
    // MARK: - Interface methods
    public func updateProgress(
        _ progress: CGFloat,
        animated: Animation = .none
    ) {
        let pinnedProgress = progress.inRange(min: 0, max: 1)
        switch animated {
        case .none:
            progressLayer.removeAnimation(forKey: AnimationKeys.progress)
            progressLayer.progress = pinnedProgress
            progressLayer.setNeedsDisplay()
        case .has(let duration):
                animate(
                    pinnedProgress,
                    duration: duration,
                    completion: nil
                )
            case .hasWithCompletion(let duration, let completion):
                animate(
                    pinnedProgress,
                    duration: duration,
                    completion: completion
                )
        }
    }
    
    // MARK: - Subtypes
    public enum Animation {
        case none
        case has(duration: CFTimeInterval)
        case hasWithCompletion(duration: CFTimeInterval, completion: SendableVoidBlock)
    }
}

// MARK: - Private methods
private extension LSProgressLoaderView {
    func animate(
        _ pinnedProgress: CGFloat,
        duration: CFTimeInterval,
        completion: SendableVoidBlock?
    ) {
        let animationDuration: CFTimeInterval = {
            if duration > .zero { return duration }
            return CFTimeInterval(abs(max(progress - self.progress, 0.3)))
        }()
        
        try? progressTimer.stop()
        try? progressTimer.start(
            updateStep: 0.03,
            finishTime: animationDuration,
            handle: { notifier in
                configureProgressHandling(
                    with: notifier,
                    animationDuration: animationDuration,
                    pinnedProgress: pinnedProgress,
                    completion: completion
                )
            })
    }
    
    func configureProgressHandling(
        with publisher: ObservableValue<Double>,
        animationDuration: CFTimeInterval,
        pinnedProgress: CGFloat,
        completion: SendableVoidBlock?
    ) {
        let currentProgress = progressLayer.progress
        publisher.addSubscriber(self, notifyOnSubscribe: false) { [weak self] progress in
            Task { @MainActor in
                self?.handleProgress(
                    progress: progress,
                    currentProgress: currentProgress,
                    animationDuration: animationDuration,
                    pinnedProgress: pinnedProgress,
                    completion: completion
                )
            }
        }
    }
    
    func handleProgress(
        progress: Double,
        currentProgress: CGFloat,
        animationDuration: CFTimeInterval,
        pinnedProgress: CGFloat,
        completion: SendableVoidBlock?
    ) {
        progressLayer.progress = (pinnedProgress - currentProgress) * (progress / animationDuration) + currentProgress
        progressLayer.setNeedsDisplay()
        if progress.isAlmostEqual(to: 1) {
            try? progressTimer.stop()
            completion?()
        }
    }
    
    func callCompletionIfHas(animation: CAAnimation) {
        let value = animation.value(forKey: AnimationKeys.completionBlock)
        guard let block = value as? VoidBlock else {
            return
        }
        block()
    }
    
    struct AnimationKeys {
        static let progress = "progress"
        static let completionBlock = "completionBlock"
        static let toValue = "toValue"
    }
}

// MARK: - Animation Delegate
extension LSProgressLoaderView: @preconcurrency CAAnimationDelegate {
    public func animationDidStop(_ animation: CAAnimation,
                                 finished flag: Bool) {
        guard flag else {
            return
        }
        progressLayer.removeAnimation(forKey: AnimationKeys.progress)
        let completedValue = animation.value(forKey: AnimationKeys.toValue)
        if let completedValue = completedValue as? CGFloat {
            if progressLayer.progress.isAlmostEqual(to: completedValue) {
                progressLayer.progress = completedValue
            }
        }
        callCompletionIfHas(animation: animation)
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct ProgressLoaderViewPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            let view = UIView()
            view.backgroundColor = .lightGray
            
            let progressView = Self.progressView
            
            view.addSubview(progressView)
            progressView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(50)
            }
            
            let button = Self.button
                .onEvent(.touchUpInside) { [progressView] in
                    var newProgress = progressView.progress + 0.1
                    newProgress = newProgress > 1.0 ? .zero : newProgress
                    progressView.updateProgress(
                        newProgress,
                        animated: .has(duration: 0.3)
                    )
                }
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(240)
                make.height.equalTo(44)
                make.top.equalTo(progressView.snp.bottom).offset(16)
            }
            return view
        }
        .previewLayout(.fixed(width: 375, height: 44))
        .edgesIgnoringSafeArea(.vertical)
    }
    
    static private var progressView: LSProgressLoaderView {
        let progress = LSProgressLoaderView()
        progress.clockwise = true
        progress.roundedCorners = false
        progress.thicknessRatio = 0.4
        return progress
    }
    
    static private var button: LSButton {
        LSButton().apply {
            $0.useTitle(normalText: "ProgressView update")
            $0.useTitleColor(
                ColorSet(
                    normal: ColorMap(color: .white),
                    highlighted: ColorMap(color: .gray)
                )
            )
            $0.useBorders(
                Borders(
                    width: 2,
                    colorSet: ColorSet(
                        normal: ColorMap(color: .white),
                        highlighted: ColorMap(color: .gray)
                    )
                )
            )
            $0.useCornerRadius(.fixed(8))
        }
    }
}
