// Apple
import SwiftUI

public struct SwiftUIPreview<Content: UIView>: UIViewRepresentable {
    // MARK: - Data
    private let content: () -> Content
    private let update: ((Content) -> Void)?
    
    // MARK: - Inits
    public init(content: @MainActor @escaping () -> Content,
                update: (@MainActor (Content) -> Void)? = nil) {
        self.content = content
        self.update = update
    }
    
    // MARK: - UIViewRepresentable
    public typealias UIViewType = Content
    public func makeUIView(context: Context) -> UIViewType {
        content()
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        update?(uiView)
    }
}
