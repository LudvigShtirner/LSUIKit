final class LSProgressLayer: CALayer {
    // MARK: - Data
    var trackTintColor = UIColor(white: 1.0, alpha: 0.3)
    var progressTintColor = UIColor.white
    var innerTintColor: UIColor?
    
    var roundedCorners = true
    var clockwise = true
    @Restricted(range: 0 ... 1) var progress = CGFloat.zero
    @Restricted(range: 0.01 ... 1) var thicknessRatio: CGFloat = 0.3
    
    // MARK: - Overrides
    override func draw(in context: CGContext) {
        let rect = bounds
        let centerPoint = CGPoint(x: rect.size.width.half,
                                  y: rect.size.height.half)
        let radius = rect.size.minSide.half
        
        let progress = min(progress, 1.nearestLower)
        var radians: CGFloat = 0
        if clockwise {
            radians = (progress * 2 * .pi) - .pi.half
        } else {
            radians = 3 * .pi.half - (progress * 2 * .pi)
        }
        
        context.setFillColor(trackTintColor.cgColor)
        let trackPath = CGMutablePath()
        trackPath.move(to: centerPoint)
        trackPath.addArc(center: centerPoint,
                         radius: radius,
                         startAngle: 2 * .pi,
                         endAngle: 0,
                         clockwise: true)
        trackPath.closeSubpath()
        context.addPath(trackPath)
        context.fillPath()
        
        if progress > .zero {
            context.setFillColor(progressTintColor.cgColor)
            let progressPath = CGMutablePath()
            progressPath.move(to: centerPoint)
            progressPath.addArc(center: centerPoint,
                                radius: radius,
                                startAngle: 3 * CGFloat.pi.half,
                                endAngle: radians,
                                clockwise: !clockwise)
            progressPath.closeSubpath()
            context.addPath(progressPath)
            context.fillPath()
            
            if roundedCorners {
                let pathWidth = radius * thicknessRatio
                let xOffset = radius * (1 + (1 - thicknessRatio.half) * cos(radians))
                let yOffset = radius * (1 + (1 - thicknessRatio.half) * sin(radians))
                let endpoint = CGPoint(x: xOffset, y: yOffset)
                
                let startEllipseRect = CGRect(x: centerPoint.x - pathWidth.half,
                                              y: .zero,
                                              width: pathWidth,
                                              height: pathWidth)
                context.addEllipse(in: startEllipseRect)
                context.fillPath()
                
                let endEllipseRect = CGRect(x: endpoint.x - pathWidth.half,
                                            y: endpoint.y - pathWidth.half,
                                            width: pathWidth,
                                            height: pathWidth)
                context.addEllipse(in: endEllipseRect)
                context.fillPath()
            }
        }
        
        context.setBlendMode(.clear)
        let innerRadius = radius * (1 - thicknessRatio)
        let clearRect = CGRect(x: centerPoint.x - innerRadius,
                               y: centerPoint.y - innerRadius,
                               width: innerRadius * 2,
                               height: innerRadius * 2)
        context.addEllipse(in: clearRect)
        context.fillPath()
        
        if let innerTintColor {
            context.setBlendMode(.normal)
            context.setFillColor(innerTintColor.cgColor)
            context.addEllipse(in: clearRect)
            context.fillPath()
        }
    }
}
