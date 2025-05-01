/// Map with colors for different color schemes
@MainActor
public struct ColorMap: Sendable {
    // MARK: - Data
    public let lightColor: UIColor
    public let darkColor: UIColor
    
    // MARK: - Inits
    public init(lightColor: UIColor,
                darkColor: UIColor) {
        self.lightColor = lightColor
        self.darkColor = darkColor
    }
    
    public init(color: UIColor) {
        self.lightColor = color
        self.darkColor = color
    }
    
    public static func make(colorMap: ColorMap,
                            anotherColorMap: ColorMap,
                            factor: CGFloat) -> ColorMap {
        let lightColor = UIColor.makeColorBetween(color: colorMap.lightColor,
                                                  anotherColor: anotherColorMap.lightColor,
                                                  factor: factor)
        let darkColor = UIColor.makeColorBetween(color: colorMap.darkColor,
                                                 anotherColor: anotherColorMap.darkColor,
                                                 factor: factor)
        return ColorMap(lightColor: lightColor,
                        darkColor: darkColor)
    }
    
    // MARK: - Interface methods
    /// Получить цвет
    /// - Parameter view: отображение для которого определяется цвет
    /// - Returns: цвет, подходящий цветовой схеме
    public func color(for view: UIView) -> UIColor {
        switch view.traitCollection.userInterfaceStyle {
        case .light, .unspecified: return lightColor
        case .dark: return darkColor
        @unknown default:
            assertionFailure("Not supported \(view.traitCollection.userInterfaceStyle)")
            return lightColor
        }
    }
}

public extension ColorMap {
    static var clear: ColorMap {
        ColorMap(color: .clear)
    }
}
