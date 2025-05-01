@MainActor
public struct LSAccess {
    let view: UIView
    
    public var animation: LSViewAnimation { LSViewAnimation(view: view) }
}

public extension UIView {
    var ls: LSAccess { LSAccess(view: self) }
}
