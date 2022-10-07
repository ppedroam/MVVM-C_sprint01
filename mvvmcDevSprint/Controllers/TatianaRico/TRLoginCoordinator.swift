//
//  TRLoginCoordinator.swift
//  mvvmcDevSprint
//
//  Created by Tatiana Rico on 29/09/22.
//

import Foundation
import UIKit

enum LoginAction {
    case resetPassword
    case createAccount
}

protocol TRLoginCoordinating {
    var controller: UIViewController? { get set }
    func perform(action: LoginAction)
}

class TRLoginCoordinator: TRLoginCoordinating {
    var controller: UIViewController?
    
    func perform(action: LoginAction) {
        switch action {
        case .resetPassword: goToResetPassword()
        case .createAccount: goToCreatAccount()
        }
    }
    
    func verifyLogin() {
        if let _ = UserDefaultsManager.UserInfos.shared.readSesion() {
            let vc = UINavigationController(rootViewController: HomeViewController())
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
    }
        
    func alertConexaoStates(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actin = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(actin)
        self.controller?.present(alertController, animated: true)
        return
    }
}

private extension TRLoginCoordinator {
    func goToResetPassword() {
        let vc = TRResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        self.controller?.present(vc, animated: true)
    }
    
    func goToCreatAccount() {
        let controller = TRCreateAccountViewController()
        controller.modalPresentationStyle = .fullScreen
        self.controller?.present(controller, animated: true)
    }
}
