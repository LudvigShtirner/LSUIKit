public protocol LSButtonInterface: UIButton {
    func useTintColor(_ tintColor: ColorMap)
    func useTitleColor(_ titleColor: ColorSet)
    func useBackgroundColors(_ backgroundColors: ColorSet)
    
    func useImageSet(_ imageSet: ImageSet)
    func useBackgroundImageSet(_ imageSet: ImageSet)
    func useTitle(normalText: String,
                  highlightText: String?,
                  disabledText: String?)
    func useFont(_ font: UIFont)
    func useNumberOfLines(_ numberOfLines: NumberOfLines)
    func useBorders(_ borders: Borders)
}

extension LSButtonInterface {
    public func useTitle(normalText: String) {
        useTitle(normalText: normalText,
                 highlightText: nil,
                 disabledText: nil)
    }
}
