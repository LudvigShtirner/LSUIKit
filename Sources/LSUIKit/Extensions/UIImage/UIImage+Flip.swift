public extension UIImage {
    func flipImage(direction: UIImageFlipDirection) throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            throw FlipError.canNotGetCGContext
        }
        let cgImage = try getCGImage()
        context.translateBy(x: direction.isHorizontal ? size.width : 0.0,
                            y: direction.isVertical ? 0.0 : size.height)
        context.scaleBy(x: direction.isHorizontal ? -scale : 1,
                        y: direction.isVertical ? 1 : -scale)
        context.draw(cgImage,
                     in: CGRect(origin: .zero,
                                size: size))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw FlipError.canNotMakeImage
        }
        return newImage
    }
}

public enum UIImageFlipDirection {
    case horizontal
    case vertical
    case both
    
    var isHorizontal: Bool {
        self != .vertical
    }
    
    var isVertical: Bool {
        self != .horizontal
    }
}


public enum FlipError: Error {
    case canNotGetCGContext
    case canNotMakeImage
}
