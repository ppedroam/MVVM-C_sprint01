//
//  ESLoginCoordinator.swift
//  mvvmcDevSprint
//
//  Created by Euclides Medeiros on 02/10/22.
//

import Foundation
import UIKit

enum LoginPasswordActions {
    case resetPasswd
    case createAccount
    case goToHome
    case alert(String,String)
}

protocol LoginCoordinatorProtocol: AnyObject {
    var controller: UIViewController? { get set }
    func perform(action: LoginPasswordActions)
    func goToResetPassword()
    func goToCreateAccount()
    func goToHomeScreen()
    func alertError(_ title: String,_ subtitle: String)
}

class ESLoginCoordinator: LoginCoordinatorProtocol {
    var controller: UIViewController?
    
    func perform(action: LoginPasswordActions) {
        switch action {
        case .resetPasswd: goToResetPassword()
        case .createAccount: goToCreateAccount()
        case .goToHome: goToHomeScreen()
        case .alert(let title, let subtitle): alertError(title, subtitle)
        }
    }
    
    
    func goToResetPassword() {
        let vc = ESResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        controller?.present(vc, animated: true)
    }
    
    func goToCreateAccount() {
        let controller = CreateAccountViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.present(controller, animated: true)
    }

    func goToHomeScreen() {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func alertError(_ title: String,_ subtitle: String) {
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let actin = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(actin)
        controller?.present(alertController, animated: true)
    }
    
}
