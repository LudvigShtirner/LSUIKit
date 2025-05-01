public struct ImageSet {
    // MARK: - Data
    let normalImage: UIImage?
    let highlightImage: UIImage?
    let disabledImage: UIImage?
    
    // MARK: - Inits
    public init(normalImage: UIImage? = nil,
                highlightImage: UIImage? = nil,
                disabledImage: UIImage? = nil) {
        self.normalImage = normalImage
        self.highlightImage = highlightImage
        self.disabledImage = disabledImage
    }
}
