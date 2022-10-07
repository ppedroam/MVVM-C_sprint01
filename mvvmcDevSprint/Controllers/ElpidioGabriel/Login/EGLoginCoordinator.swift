//
//  EGLoginCoordinator.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Aragao on 06/10/22.
//

import UIKit

protocol EGLoginCoordinatorProtocol: AnyObject {
    var controller: UIViewController? { get set }
    func goToHomeView()
    func goToCreateAccount()
    func goToResetPassword()
}

class EGLoginCoordinator: EGLoginCoordinatorProtocol {
    
    weak  var controller: UIViewController?
    
    func goToHomeView() {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func goToCreateAccount() {
        let controller = CreateAccountViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.present(controller, animated: true)
    }
    
    func goToResetPassword() {
        let vc = EGResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        controller?.present(vc, animated: true)
    }
}
