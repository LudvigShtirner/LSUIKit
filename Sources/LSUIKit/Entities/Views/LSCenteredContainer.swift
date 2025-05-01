public final class LSCenteredContainer: LSView {
    private let content: UIView
    private let viewController: UIViewController?
    private let width: Width
    private let height: Height
    
    public init(content: UIView,
                width: Width = .none,
                height: Height = .none) {
        self.content = content
        self.width = width
        self.height = height
        self.viewController = nil
        super.init(frame: .zero)
    }
    
    public init(contentVC: UIViewController,
                width: Width = .none,
                height: Height = .none) {
        self.content = contentVC.view
        self.width = width
        self.height = height
        self.viewController = contentVC
        super.init(frame: .zero)
    }
    
    // MARK: - Overrides
    public override func setupUI() {
        addSubview(content)
    }
    
    public override func setupConstraints() {
        content.snp.makeConstraints { make in
            make.center.equalToSuperview()
            switch width {
                case .none: break
                case .fixed(let width): make.width.equalTo(width)
                case .equalSuperview: make.width.equalToSuperview()
            }
            switch height {
                case .none: break
                case .fixed(let height): make.height.equalTo(height)
                case .equalSuperview: make.height.equalToSuperview()
            }
        }
    }
    
    public enum Width {
        case none
        case fixed(CGFloat)
        case equalSuperview
    }
    
    public enum Height {
        case none
        case fixed(CGFloat)
        case equalSuperview
    }
}
