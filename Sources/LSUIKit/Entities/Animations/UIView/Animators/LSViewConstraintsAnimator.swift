struct LSViewConstraintsAnimator {
    // MARK: - Data
    private let view: UIView
    private let constraintsSetAction: VoidBlock
    private let completion: BoolBlock?
    
    // MARK: - Inits
    init(view: UIView,
         constraintsSetAction: @escaping VoidBlock,
         completion: BoolBlock?) {
        self.view = view
        self.constraintsSetAction = constraintsSetAction
        self.completion = completion
    }
}

// MARK: - LSAnimator
extension LSViewConstraintsAnimator: LSAnimator {
    func alreadyAtFinishState() -> Bool { false }
    func preaction() { }
    
    func runAnimation() {
        constraintsSetAction()
        view.layoutIfNeeded()
    }
    
    func completeAnimation(duration: TimeInterval,
                           success: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [self] in
            self.completion?(success)
        }
    }
}

// MARK: - SwiftUI Preview
import SwiftUI

struct LSViewConstraintsAnimatorPreviews: PreviewProvider {
    static var previews: some View {
        SwiftUIPreview {
            let view = LSView()
            
            let innerView = LSView().apply {
                $0.useBackgroundColor(.init(color: .red))
            }
                
            view.addSubview(innerView)
            innerView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(100)
            }
            innerView.ls.animation
                .constraints {
                    innerView.snp.remakeConstraints { make in
                        make.center.equalToSuperview().offset(100)
                        make.width.height.equalTo(100)
                    }
                    view.layoutIfNeeded()
                }
                .execute(duration: 2.0, options: .curveEaseInOut)
            
            return view
        }
        .previewLayout(.fixed(width: 375, height: 44))
        .edgesIgnoringSafeArea(.vertical)
    }
}
