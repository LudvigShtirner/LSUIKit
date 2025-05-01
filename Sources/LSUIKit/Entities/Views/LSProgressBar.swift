public final class ProgressBar: LSView {
    // MARK: - UI
    private let fillView = LSView()
    
    // MARK: - Data
    private var progress = CGFloat.zero
    
    // MARK: - Overrides
    public override func setupUI() {
        addSubview(fillView)
    }
    
    public override func setupConstraints() {
        fillView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(progress)
        }
    }
    
    // MARK: - Interface methods
    @MainActor
    public func updateFillColor(_ fillColor: ColorMap) {
        fillView.useBackgroundColor(fillColor)
    }
    
    @MainActor
    public func updateProgress(_ progress: CGFloat,
                               animated: Bool) {
        self.progress = progress
        if animated {
            updateProgressAnimated()
        } else {
            updateProgress()
        }
    }
}

private extension ProgressBar {
    func updateProgressAnimated() {
        UIView.animate(
            withDuration: 0.2,
            delay: .zero,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: { [weak self] in
                self?.updateProgress()
            },
            completion: nil
        )
//        ls.animation
//            .constraints { [weak self] in
//                self?.updateProgress()
//            }
//            .execute(duration: 0.2,
//                     options: [.beginFromCurrentState, .curveEaseInOut])
    }
    
    func updateProgress() {
        fillView.snp.updateConstraints { make in
            make.width.equalToSuperview().multipliedBy(progress)
        }
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct ProgressBarPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            let progressBar = ProgressBar().apply {
                $0.useBackgroundColor(ColorMap(color: .lightGray))
                $0.useCornerRadius(.fixed(8))
                $0.clipsToBounds = true
                $0.updateFillColor(ColorMap(color: .red))
                $0.updateProgress(0.01, animated: false)
            }
                
            let button = LSButton().apply {
                $0.useTitle(normalText: "Increment")
                $0.useTitleColor(
                    ColorSet(
                        normal: ColorMap(color: .white)
                    )
                )
                $0.useBackgroundColors(
                    ColorSet(
                        normal: ColorMap(color: .magenta),
                        highlighted: ColorMap(color: .magenta.withAlphaComponent(0.5))
                    )
                )
                $0.useCornerRadius(.fixed(8))
                $0.clipsToBounds = true
            }
            
            let container = LSView()
            container.addSubview(progressBar)
            container.addSubview(button)
            
            var progress = CGFloat.zero
            button.onEvent(.touchUpInside) { [weak progressBar] in
                progress += 0.1
                if progress > 1 {
                    progress = .zero
                }
                progressBar?.updateProgress(progress, animated: true)
            }
            
            progressBar.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(30)
            }
            button.snp.makeConstraints { make in
                make.top.equalTo(progressBar.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(44)
                make.bottom.equalToSuperview()
            }
            
            return LSCenteredContainer(
                content: container,
                width: .fixed(300)
            )
        }
        .previewLayout(.fixed(width: 375, height: 44))
        .edgesIgnoringSafeArea(.vertical)
    }
}
