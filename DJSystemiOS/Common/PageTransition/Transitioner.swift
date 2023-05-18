import UIKit

protocol Transitioner: AnyObject where Self: UIViewController {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func present(viewController: UIViewController,
                 animated: Bool,
                 completion: (() -> ())?)
    func dismiss(animated: Bool)
}

extension Transitioner {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let nc = navigationController else { return }
        nc.pushViewController(viewController, animated: animated)
    }
    func present(viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        present(viewController, animated: animated, completion: completion)
    }
    func dismiss(animated: Bool) {
        dismiss(animated: animated)
    }
}
