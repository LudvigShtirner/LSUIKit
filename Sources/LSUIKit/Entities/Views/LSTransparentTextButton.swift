public final class LSTransparentTextButton: LSButton {
    // MARK: - LSButtonDrawer
    
    public override func draw(_ rect: CGRect) {
        guard let image = maskedImage(rect: rect) else {
            return
        }
        let mask = CALayer()
        mask.contents = image
        mask.frame = bounds
        layer.mask = mask
    }
    
    // MARK: - Private methods
    @MainActor
    private func maskedImage(rect: CGRect) -> CGImage? {
        guard rect.isEmpty == false,
              let textImage = titleLabel?.makeTextImage(with: rect.size),
              let maskImage = textImage.maskImage()
        else {
            return nil
        }
        return maskImage
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct LSButtonTransparentTextDrawerPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            let button = LSTransparentTextButton().apply {
                $0.useBackgroundColors(
                    ColorSet(
                        normal: ColorMap(color: .blue),
                        highlighted: ColorMap(color: .red)
                    )
                )
                $0.useTitleColor(
                    ColorSet(
                        normal: ColorMap(color: .white)
                    )
                )
                $0.useTitle(normalText: "Some Text provided to button")
                $0.useCornerRadius(.circled)
                $0.clipsToBounds = true
            }
            return LSCenteredContainer(
                content: button,
                width: .fixed(260),
                height: .fixed(64)
            ).apply {
                $0.backgroundColor = .darkGray
            }
        }
        .previewLayout(.fixed(width: 375, height: 120))
        .edgesIgnoringSafeArea(.vertical)
    }
}
