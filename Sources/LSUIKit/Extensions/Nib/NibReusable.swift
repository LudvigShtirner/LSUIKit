public protocol NibReusable: UIView, ClassIdentifiable {
    static var nibName: String { get }
}

public extension NibReusable {
    static var nibName: String { className }
}
