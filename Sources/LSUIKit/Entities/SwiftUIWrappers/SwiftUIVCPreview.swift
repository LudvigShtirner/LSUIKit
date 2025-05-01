// Apple
import SwiftUI

public struct SwiftUIVCPreview<T: UIViewController>: UIViewControllerRepresentable {
    // MARK: - Data
    private let content: () -> T
    private let update: ((T) -> Void)?
    
    // MARK: - Inits
    public init(content: @escaping () -> T,
                update: ((T) -> Void)? = nil) {
        self.content = content
        self.update = update
    }
    
    // MARK: - UIViewControllerRepresentable
    public typealias UIViewType = T
    public func makeUIViewController(context: Context) -> T {
        content()
    }
    
    public func updateUIViewController(_ uiViewController: T, context: Context) {
        update?(uiViewController)
    }
}
