public extension UIDevice {
    var hasRoundedCorners: Bool {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .filter { $0.isKeyWindow }
            .first { $0.safeAreaInsets.top >= 44 } != nil
    }
}
