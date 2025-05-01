public extension UILabel {
    func makeTextImage(with size: CGSize) -> UIImage? {
        guard let text else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: textColor as Any
        ]
        let textSize = text.size(withAttributes: attributes)
        let point = CGPoint(x: (size.width - textSize.width).half - UIScreen.mainScreenPixelSize,
                            y: (size.height - textSize.height).half - UIScreen.mainScreenPixelSize)
        text.draw(at: point, withAttributes: attributes)
        
        let textImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return textImage
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct UILabelPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            let label = UILabel()
            label.text = "Some text"
            label.font = .systemFont(ofSize: 48)
            label.textColor = .red
            
            let size = label.text!.size(withAttributes: [.font: label.font as Any])
            
            let imageView = UIButton()
            imageView.setImage(label.makeTextImage(with: size), for: .normal)
            return imageView
        }
        .previewLayout(.fixed(width: 375, height: 120))
        .edgesIgnoringSafeArea(.vertical)
    }
}

