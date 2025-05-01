public extension CIContext {
    nonisolated(unsafe) static let shared = CIContext()
}

public extension UIImage {
    func getCGImage() throws -> CGImage {
        if let cgImage {
            return cgImage
        }
        guard let ciImage else {
            throw UIImageConverterError.imageDoesNotFacedWithCoreGraphicsOrCoreImage
        }
        guard let createdImage = CIContext.shared.createCGImage(ciImage, from: ciImage.extent) else {
            throw UIImageConverterError.contextError
        }
        return createdImage
    }
    
    func getCIImage() throws -> CIImage {
        if let ciImage {
            return ciImage
        }
        guard let cgimage = cgImage else {
            throw UIImageConverterError.imageDoesNotFacedWithCoreGraphicsOrCoreImage
        }
        return CIImage(cgImage: cgimage)
    }
}

public enum UIImageConverterError: Error {
    case imageDoesNotFacedWithCoreGraphicsOrCoreImage
    case contextError
}

