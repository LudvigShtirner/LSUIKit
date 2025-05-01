open class LSLinearGradient: LSView {
    // MARK: - UI
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Data
    public var config: Config {
        didSet {
            update()
        }
    }
    
    // MARK: - Inits
    public init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        update()
    }
    
    // MARK: - Overrides
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // MARK: - LSView
    open override func setupUI() {
        layer.addSublayer(gradientLayer)
    }
    
    open override func setupColors() {
        gradientLayer.colors = [
            config.startColor.color(for: self).cgColor,
            config.endColor.color(for: self).cgColor
        ]
    }
    
    private func update() {
        gradientLayer.type = .axial
        let pivots = config.startsFrom.turnIntoPivots()
        gradientLayer.startPoint = pivots.start
        gradientLayer.endPoint = pivots.end
    }
    
    // MARK: - Subtypes
    public struct Config {
        let startColor: ColorMap
        let endColor: ColorMap
        let startsFrom: Direction
        
        public init(startColor: ColorMap,
                    endColor: ColorMap,
                    startsFrom: Direction) {
            self.startColor = startColor
            self.endColor = endColor
            self.startsFrom = startsFrom
        }
    }
    
    public enum Direction {
        case top
        case bottom
        case left
        case right
        case topLeft
        case bottomLeft
        case topRight
        case bottomRight
        case custom(CGPoint, CGPoint)
        
        fileprivate func turnIntoPivots() -> (start: CGPoint, end: CGPoint) {
            switch self {
            case .top:
                return (Self.topPoint, Self.bottomPoint)
            case .bottom:
                return (Self.bottomPoint, Self.topPoint)
            case .left:
                return (Self.leftPoint, Self.rightPoint)
            case .right:
                return (Self.rightPoint, Self.leftPoint)
            case .custom(let start, let end):
                return (start, end)
            case .topLeft:
                return (Self.topLeftPoint, Self.bottomRightPoint)
            case .bottomLeft:
                return (Self.bottomLeftPoint, Self.topRightPoint)
            case .topRight:
                return (Self.topRightPoint, Self.bottomLeftPoint)
            case .bottomRight:
                return (Self.bottomRightPoint, Self.topLeftPoint)
            }
        }
        
        static private var leftPoint: CGPoint { CGPoint(x: .zero, y: 0.5) }
        static private var rightPoint: CGPoint { CGPoint(x: 1.0, y: 0.5) }
        static private var topPoint: CGPoint { CGPoint(x: 0.5, y: .zero) }
        static private var bottomPoint: CGPoint { CGPoint(x: 0.5, y: 1.0) }
        
        static private var topLeftPoint: CGPoint { CGPoint.zero }
        static private var bottomLeftPoint: CGPoint { CGPoint(x: .zero, y: 1.0) }
        static private var topRightPoint: CGPoint { CGPoint(x: 1.0, y: .zero) }
        static private var bottomRightPoint: CGPoint { CGPoint(x: 1.0, y: 1.0) }
    }
}


// MARK: - SwiftUI Preview
import SwiftUI

struct LinearGradientPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            LSLinearGradient(
                config: LSLinearGradient.Config(
                    startColor: ColorMap(color: .red),
                    endColor: ColorMap(color: .blue.withAlphaComponent(0.2)),
                    startsFrom: .right
                )
            )
        }
        .previewLayout(.fixed(width: 375, height: 375))
        .edgesIgnoringSafeArea(.vertical)
    }
}
