public extension UILabel {
    /// Obtain label font after shrinking
    /// - Warning: text must set before asking actual font
    func calcActualFont() -> UIFont {
        guard let txt = text else {
            assertionFailure("No text, no calculations")
            return font
        }
        let attributedString = NSAttributedString(string: txt,
                                                  attributes: [
                                                    .font: font as Any
                                                  ])
        let drawingContext = NSStringDrawingContext()
        drawingContext.minimumScaleFactor = minimumScaleFactor
        attributedString.boundingRect(with: bounds.size,
                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                      context: drawingContext)
        
        let fontSize = font.pointSize * drawingContext.actualScaleFactor
        let flooredFontSize: CGFloat = floor(fontSize)
        return font.withSize(flooredFontSize)
    }
}

