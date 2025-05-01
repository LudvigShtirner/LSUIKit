@MainActor
protocol LSAnimator {
    func alreadyAtFinishState() -> Bool
    func preaction()
    func runAnimation()
    func completeAnimation(duration: TimeInterval,
                           success: Bool)
}
