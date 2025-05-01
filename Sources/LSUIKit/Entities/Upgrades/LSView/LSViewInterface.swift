public protocol LSViewInterface: LSViewInterfaceCommon {
    func useBackgroundColor(_ backgroundColor: ColorMap)
    func useBorder(_ border: Border)
}

protocol LSViewInterfaceInternal: LSViewInterfaceInternalCommon {
    var lsBackgroundColor: BackgroundColorApplier? { get set }
    var lsBorder: BorderApplier? { get set }
}

extension LSViewInterfaceInternal {
    public func useBackgroundColor(_ backgroundColor: ColorMap) {
        self.lsBackgroundColor = BackgroundColorApplier(value: backgroundColor)
        self.lsBackgroundColor?.apply(to: self)
    }
    
    public func useBorder(_ border: Border) {
        self.lsBorder = BorderApplier(border: border)
        self.lsBorder?.apply(to: self)
    }
}
