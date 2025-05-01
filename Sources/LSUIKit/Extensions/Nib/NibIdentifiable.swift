public extension UIView {
    static var nib: UINib {
        UINib(nibName: className, bundle: nil)
    }
    
    static func instantiateFromNib() -> Self {
        let instances = nib.instantiate(withOwner: nil, options: nil)
        guard let view = instances.first as? Self else {
            fatalError("Couldn't find nib file for \(className)")
        }
        return view
    }
}

public extension UIViewController {
    static func instantiateFromNib() -> Self {
        Self(nibName: className, bundle: Bundle(for: Self.self))
    }
}

