@MainActor
protocol LSKeyFrameAnimator {
    var key: String { get }
    
    func alreadyAtFinishState() -> Bool
    func preaction()
    func runAnimation(_ animation: CAKeyframeAnimation)
    func completeAnimation(success: Bool)
}
