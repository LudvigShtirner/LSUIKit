public extension UIColor {
    func transition(to color: UIColor,
                    progress: CGFloat) -> UIColor {
        let currentChannels = getChannels()
        let anotherChannels = color.getChannels()
        return UIColor(red: currentChannels.red + (anotherChannels.red - currentChannels.red) * progress,
                       green: currentChannels.green + (anotherChannels.green - currentChannels.green) * progress,
                       blue: currentChannels.blue + (anotherChannels.blue - currentChannels.blue) * progress,
                       alpha: currentChannels.alpha + (anotherChannels.alpha - currentChannels.alpha) * progress)
    }
    
    static func makeColorBetween(color: UIColor,
                                 anotherColor: UIColor,
                                 factor: CGFloat) -> UIColor {
        color.transition(to: anotherColor, progress: factor)
    }
    
    func getChannels() -> (red: CGFloat,
                           green: CGFloat,
                           blue: CGFloat,
                           alpha: CGFloat) {
        var red: CGFloat = .zero
        var green: CGFloat = .zero
        var blue: CGFloat = .zero
        var alpha: CGFloat = .zero
        _ = getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )
        return (red, green, blue, alpha)
    }
}

