struct BordersApplier: ParameterApplier {
    private let borders: Borders
    
    init(borders: Borders) {
        self.borders = borders
    }
    
    @MainActor
    func apply(to element: UIButton) {
        element.layer.borderWidth = borders.width
        element.layer.borderColor = borders.colorSet.current(
            isHighlighted: element.isHighlighted,
            isEnabled: element.isEnabled
        )
        .color(for: element)
        .cgColor
    }
}
