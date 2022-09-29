//
//  TRLoginCoordinator.swift
//  mvvmcDevSprint
//
//  Created by Tatiana Rico on 29/09/22.
//

import Foundation
import UIKit

class TRLoginCoordinator {
    var vc: UIViewController?
    
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
    
    func goToResetPassword() {
        let vc = TRResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        self.vc?.present(vc, animated: true)
    }
    
    func goToCreatAccount(){
    let controller = TRCreateAccountViewController()
    controller.modalPresentationStyle = .fullScreen
        self.vc?.present(controller, animated: true)
}
    
    func alertConexaoStates(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actin = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(actin)
        self.vc?.present(alertController, animated: true)
        return
    }
}
