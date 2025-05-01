// SPM
import SnapKit

public extension UIViewController {
    /// Связать контроллер как дочерний
    /// - Parameters:
    ///   - viewController: дочернее отображение
    ///   - container: контейнер для дочернего объекта
    func embedViewController(
        _ viewController: UIViewController,
        into container: UIView
    ) {
        loadViewIfNeeded()
        
        addChild(viewController)
        container.addSubview(viewController.view)
        
        viewController.view.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        viewController.didMove(toParent: self)
    }
}
