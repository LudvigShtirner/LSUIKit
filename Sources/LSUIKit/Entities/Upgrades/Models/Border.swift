// Apple
import CoreGraphics

public struct Border {
    let width: CGFloat
    let colorMap: ColorMap
    
    public init(
        width: CGFloat,
        colorMap: ColorMap
    ) {
        self.width = width
        self.colorMap = colorMap
    }
}

public struct Borders {
    let width: CGFloat
    let colorSet: ColorSet
    
    public init(
        width: CGFloat,
        colorSet: ColorSet
    ) {
        self.width = width
        self.colorSet = colorSet
    }
}
