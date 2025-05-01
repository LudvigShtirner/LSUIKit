public extension UIColor {
    static func make(with red: Int,
                     _ green: Int,
                     _ blue: Int) -> UIColor {
        UIColor(red: channel(red),
                green: channel(green),
                blue: channel(blue),
                alpha: 1.0)
    }
    
    static func random() -> UIColor {
        UIColor(red: channel(.random(in: (0 ... 255))),
                green: channel(.random(in: (0 ... 255))),
                blue: channel(.random(in: (0 ... 255))),
                alpha: 1.0)
    }
    
    static func channel(_ value: Int) -> CGFloat {
        CGFloat(value.inRange(min: 0, max: 255)) / 255.0
    }
}

