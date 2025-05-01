public struct TitleColorApplier: ParameterApplier {
    // MARK: - Data
    private var titleColorSet: ColorSet
    
    // MARK: - Inits
    init(titleColorSet: ColorSet) {
        self.titleColorSet = titleColorSet
    }
    
    // MARK: - ParameterApplier
    func apply(to element: UIButton) {
        element.setTitleColor(titleColorSet.normal.color(for: element), for: .normal)
        element.setTitleColor(titleColorSet.highlighted.color(for: element), for: .highlighted)
        element.setTitleColor(titleColorSet.disabled.color(for: element), for: .disabled)
    }
}
