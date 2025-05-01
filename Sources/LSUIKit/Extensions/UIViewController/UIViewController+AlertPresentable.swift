public extension UIViewController {
    func showAlert(style: UIAlertController.Style,
                   model: AlertData) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: style
        )
        let cancelAction = model.cancelAction.alertAction
        alertController.addAction(cancelAction)
        for action in model.actions {
            alertController.addAction(action.alertAction)
        }
        present(alertController, animated: true)
    }
}

public struct AlertData {
    // MARK: - Data
    let title: String
    let message: String
    let cancelAction: Action
    let actions: [Action]
    
    // MARK: - Inits
    public init(title: String,
                message: String,
                cancelAction: AlertData.Action,
                actions: [AlertData.Action] = []) {
        self.title = title
        self.message = message
        self.cancelAction = cancelAction
        self.actions = actions
    }
    
    // MARK: - Subtypes
    @MainActor
    public struct Action {
        // MARK: - Data
        let buttonTitle: String
        let buttonStyle: UIAlertAction.Style
        let buttonAction: VoidBlock?
        
        // MARK: - Inits
        public init(buttonTitle: String,
                    buttonStyle: UIAlertAction.Style,
                    buttonAction: VoidBlock?) {
            self.buttonTitle = buttonTitle
            self.buttonStyle = buttonStyle
            self.buttonAction = buttonAction
        }
        
        // MARK: - Interface methods
        var alertAction: UIAlertAction {
            UIAlertAction(title: buttonTitle, style: buttonStyle) { _ in
                self.buttonAction?()
            }
        }
    }
}

