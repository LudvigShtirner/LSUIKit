public struct UIConfiguration<T> {
    // MARK: - Data
    private let styling: (T) -> Void
    
    // MARK: - Inits
    public init(styling: @escaping (T) -> Void) {
        self.styling = styling
    }
    
    // MARK: - Interface methods
    func apply(to view: T) {
        styling(view)
    }
    
    public func compose(with other: UIConfiguration<T>) -> Self {
        UIConfiguration {
            self.apply(to: $0)
            other.apply(to: $0)
        }
    }
    
    public static func compose(_ styles: UIConfiguration<T>...) -> Self {
        UIConfiguration { view in
            styles.forEach { $0.apply(to: view) }
        }
    }
}
