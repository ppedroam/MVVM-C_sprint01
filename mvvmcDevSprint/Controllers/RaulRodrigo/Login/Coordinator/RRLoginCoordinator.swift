//
//  RRLoginCoordinator.swift
//  mvvmcDevSprint
//
//  Created by Raul Rodrigo on 03/10/22.
//

import UIKit

enum RRLoginCoordinationActions {
    case home
    case close
}

protocol RRLoginCoordinating: AnyObject {
    var controller: UIViewController? { get set }
    func perform(action: RRLoginCoordinationActions)
}

class RRLoginCoordinator: RRLoginCoordinating {
    var controller: UIViewController?
    
    func perform(action: RRLoginCoordinationActions) {
        switch action {
        case .home: goToHome()
        case .close: controller?.dismiss(animated: true)
       
        }
    }
}

private extension RRLoginCoordinator {
    func goToHome() {
        let homeViewController = HomeViewController()
        homeViewController.lastController = String(describing: self)
        let vc = UINavigationController(rootViewController: homeViewController)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
