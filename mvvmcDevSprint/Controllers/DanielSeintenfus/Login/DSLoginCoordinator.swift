//
//  DSLoginCoordinator.swift
//  mvvmcDevSprint
//
//  Created by CAF on 06/10/22.
//

import Foundation
import UIKit

enum DSLoginActions {
    case resetPassword
    case createAccount
    case home
    case close
}

class DSLoginCoordinator {
    var viewController: UIViewController?
    
    func perform(action: DSLoginActions) {
        switch action {
        case .resetPassword: goToResetPassword()
        case .createAccount: goToCreateAccount()
        case .home: goToHome()
        case .close: viewController?.dismiss(animated: true)
        }
    }
}

private extension DSLoginCoordinator {
    func goToResetPassword() {
        let vc = DSResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func goToCreateAccount(){
        let vc = DSCreateAccountViewController()
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func goToHome(){
        let vc = UINavigationController(rootViewController: HomeViewController())
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
}
