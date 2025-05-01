public protocol LSImageViewInterface: UIImageView {
    func useTintColor(_ tintColor: ColorMap)
    
    func useImage(_ image: UIImage?)
    func useHighlightedImage(_ highlightedImage: UIImage?)
}
