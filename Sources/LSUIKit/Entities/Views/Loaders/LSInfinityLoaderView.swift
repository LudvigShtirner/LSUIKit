public final class LSInfinityLoaderView: LSView {
    // MARK: - Data
    public var duration: CFTimeInterval = 1.0
    
    // MARK: - Proxies
    static let updateLayer: (LSInfinityLoaderView, Any) -> Void = { (instance, _) in
        instance.progressLayer!.setNeedsDisplay()
    }
    
    @ProxyWithAction(\.progressLayer.trackTintColor, extraAction: LSInfinityLoaderView.updateLayer)
    public var trackTintColor: UIColor
    
    @ProxyWithAction(\.progressLayer.progressTintColor, extraAction: LSInfinityLoaderView.updateLayer)
    public var progressTintColor: UIColor
    
    @ProxyWithAction(\.progressLayer.innerTintColor, extraAction: LSInfinityLoaderView.updateLayer)
    public var innerTintColor: UIColor?
    
    @ProxyWithAction(\.progressLayer.roundedCorners, extraAction: LSInfinityLoaderView.updateLayer)
    public var roundedCorners: Bool
    
    @ProxyWithAction(\.progressLayer.thicknessRatio, extraAction: LSInfinityLoaderView.updateLayer)
    public var thicknessRatio: CGFloat
    
    @ProxyWithAction(\.progressLayer.clockwise, extraAction: LSInfinityLoaderView.updateLayer)
    public var clockwise: Bool
    
    @Proxy(\.progressLayer.progress)
    public var progress: CGFloat
    
    var isAnimating: Bool {
        progressLayer.animation(forKey: AnimationKeys.animation) != nil
    }
    
    // MARK: - Life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isHidden = true
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
    public func startAnimation() {
        stopAnimation()
        addAnimation()
        isHidden = false
    }
    
    public func stopAnimation() {
        guard isAnimating else {
            return
        }
        isHidden = true
        progressLayer.removeAnimation(forKey: AnimationKeys.animation)
    }
}

// MARK: - Private methods
private extension LSInfinityLoaderView {
    func addAnimation() {
        let animation = CABasicAnimation(keyPath: AnimationKeys.transformRotation)
        animation.byValue = clockwise ? 2 * Double.pi : -2 * Double.pi
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: AnimationKeys.animation)
    }
    
    struct AnimationKeys {
        static let animation = "animation"
        static let transformRotation = "transform.rotation"
        static let toValue = "toValue"
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct InfinityLoaderViewPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            let view = UIView()
            
            let loader = LSInfinityLoaderView()
            view.addSubview(loader)
            loader.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(30)
            }
            loader.progress = 0.7
            loader.clockwise = false
            loader.roundedCorners = true
            loader.thicknessRatio = 0.17
            loader.trackTintColor = .clear
            loader.progressTintColor = .purple
            
            let button = LSButton().apply {
                $0.useTitle(normalText: "LoaderView Toggle")
                $0.useTitleColor(
                    ColorSet(
                        normal: ColorMap(color: .purple),
                        highlighted: ColorMap(color: .purple.withAlphaComponent(0.3))
                    )
                )
                $0.useBorders(
                    Borders(
                        width: 2,
                        colorSet: ColorSet(
                            normal: ColorMap(color: .purple),
                            highlighted: ColorMap(color: .purple.withAlphaComponent(0.3))
                        )
                    )
                )
                $0.useCornerRadius(.fixed(8))
                $0.onEvent(.touchUpInside) { [weak loader] in
                    guard let loader else { return }
                    if loader.isAnimating {
                        loader.stopAnimation()
                    } else {
                        loader.startAnimation()
                    }
                }
            }
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(240)
                make.height.equalTo(44)
                make.top.equalTo(loader.snp.bottom).offset(16)
            }
            
            return view
        }
        .previewLayout(.fixed(width: 375, height: 44))
        .edgesIgnoringSafeArea(.vertical)
    }
}
