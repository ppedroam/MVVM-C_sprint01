import Foundation
import UIKit

enum BBLoginActions {
    case home
    case resetPassword
    case createAccount
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
        case .resetPassword: goToResetPassword()
        case .createAccount: goToCreateAccount()
        }
    }
}

private extension BBLoginCoordinating {
    func goToHome() {
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        controller?.navigationController?.present(vc, animated: true)
    }
    
    func goToResetPassword() {
        let vc = ResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        controller?.present(vc, animated: true)
    }
    
    func goToCreateAccount() {
        let vc = CreateAccountViewController()
        vc.modalPresentationStyle = .fullScreen
        controller?.present(vc, animated: true)
    }
}
