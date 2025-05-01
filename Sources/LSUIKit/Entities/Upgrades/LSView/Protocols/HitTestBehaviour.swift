@MainActor
public protocol HitTestBehaviour: AnyObject {
    func hitTest(_ point: CGPoint,
                 with event: UIEvent?) -> UIView?
}
