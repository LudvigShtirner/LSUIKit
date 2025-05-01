import CoreImage
import CoreImage.CIFilterBuiltins

final class MetaBallEffectFilter: CIFilter {
    // MARK: - Filters
    private let blurFilter: CIFilter & CIGaussianBlur = {
        let blur = CIFilter.gaussianBlur()
        blur.radius = 30
        return blur
    }()
    private let thresholdFilter = LumaThresholdFilter()
    
    // MARK: - Data
    var blur: Float {
        get { blurFilter.radius }
        set { blurFilter.setValue(newValue, forKey: kCIInputRadiusKey) }
    }
    
    // MARK: - Overrides
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let inputImage = self.inputImage else { return nil }
        blurFilter.inputImage = inputImage
        let blurredOutput = blurFilter.outputImage
        thresholdFilter.inputImage = blurredOutput
        let lumaImage = thresholdFilter.outputImage
        return lumaImage
    }
}
