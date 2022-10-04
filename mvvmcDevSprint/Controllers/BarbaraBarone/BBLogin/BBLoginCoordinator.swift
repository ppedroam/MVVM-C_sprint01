import Foundation
import UIKit

enum BBLoginActions {
    case home
}

protocol BBLoginCoordinating: AnyObject {
    var controller: UIViewController? { get set }
    func perform(action: BBLoginActions)
}

final class BBLoginCoordinator: BBLoginCoordinating {
    var controller: UIViewController?
    
    func perform(action: BBLoginActions) {
        switch action {
        case .home: goToHome()
        }
    }
}

private extension BBLoginCoordinating {
    func goToHome() {
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        controller?.navigationController?.present(vc, animated: true)
    }
}
