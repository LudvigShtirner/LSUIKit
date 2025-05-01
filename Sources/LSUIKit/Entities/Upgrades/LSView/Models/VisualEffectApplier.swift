@MainActor
struct VisualEffectApplier: ParameterApplier {
    // MARK: - Data
    private let value: LSVisualEffect
    
    // MARK: - Inits
    init(value: LSVisualEffect) {
        self.value = value
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UIView) {
        element.subviews
            .filter { $0 is UIVisualEffectView }
            .forEach { $0.removeFromSuperview() }
        switch value {
            case .none:
                break
            case .blur(let blurEffect):
                let effectView = UIVisualEffectView()
                effectView.effect = blurEffect
                element.addSubview(effectView)
                effectView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
        }
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct BlurViewPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            let view = UIImageView()
            view.image = UIImage(systemName: "swift")
            view.tintColor = .red
            
            let blurView = LSView()
            blurView.useEffect(.blur(UIBlurEffect(style: .light)))
            view.addSubview(blurView)
            blurView.snp.makeConstraints { make in
                make.directionalEdges.equalToSuperview()
            }
            return LSCenteredContainer(
                content: view,
                width: .fixed(200),
                height: .fixed(200)
            )
        }
        .previewLayout(.fixed(width: 375, height: 44))
        .edgesIgnoringSafeArea(.vertical)
    }
}
