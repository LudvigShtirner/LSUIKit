@MainActor
protocol ParameterApplier {
    associatedtype Element
    func apply(to element: Element)
}
