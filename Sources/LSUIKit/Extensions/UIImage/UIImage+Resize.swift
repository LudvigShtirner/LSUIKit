// Apple
import AVFoundation

public extension UIImage {
    func resized(within newSize: CGSize,
                 outputScale: CGFloat? = nil) -> UIImage {
        let withinBounds = CGRect(origin: .zero, size: newSize)
        var newFrame = AVMakeRect(aspectRatio: size, insideRect: withinBounds)
        newFrame.origin = .zero
        
        let format = UIGraphicsImageRendererFormat.preferred()
        if let outputScale {
            format.scale = outputScale
        }
        let renderer = UIGraphicsImageRenderer(size: newFrame.size, format: format)
        let image = renderer.image { _ in
            self.draw(in: newFrame)
        }
        return image.withRenderingMode(renderingMode)
    }
}
