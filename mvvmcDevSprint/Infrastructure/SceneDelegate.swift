//
//  SceneDelegate.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 22/09/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let controller = AppCoordinator.shared.getRootViewController()

        let navVC = UINavigationController()
        let cordinator = FAAuthenticationCoordinator()
        cordinator.navigationController = navVC
        let window = UIWindow(windowScene: windowScene)

        if isFASController(controller) {
            window.rootViewController = navVC
            cordinator.start()
        } else {
            window.rootViewController = controller
        }
        window.makeKeyAndVisible()
        self.window = window
        
    }

    func isFASController(_ controller: UIViewController) -> Bool {
        guard let control = controller as? FALoginViewController else {
            return false
        }
        return true
    }
}

