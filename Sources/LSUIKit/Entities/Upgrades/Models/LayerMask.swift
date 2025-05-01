public enum LayerMask {
    case none
    case path(() -> UIBezierPath, CAShapeLayerFillRule)
    case content(() -> CGImage?)
}
