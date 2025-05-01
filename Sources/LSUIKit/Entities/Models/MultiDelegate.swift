public final class MultiDelegate<T: AnyObject>: NSObject {
    // MARK: - Data
    private var delegates = [WeakBox<T>]()
    
    // MARK: - Interface methods
    public func addDelegate(_ delegate: T) {
        delegates.append(WeakBox(delegate))
    }
    
    public func removeDelegate(_ delegate: T) {
        delegates = delegates.filter { $0.unbox !== delegate && $0.unbox != nil }
    }
    
    @discardableResult
    public func call<ResultType>(_ closure: (T) -> ResultType?) -> [ResultType] {
        delegates.compactMap {
            if let delegate = $0.unbox {
                return closure(delegate)
            }
            return nil
        }
    }
}
