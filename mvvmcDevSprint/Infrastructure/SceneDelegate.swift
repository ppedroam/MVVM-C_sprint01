//
//  SceneDelegate.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 22/09/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let appCoordinator = AppCoordinator(loggedUserChecker: LoggedUserChecker())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = appCoordinator.getRootViewController()
        self.window?.rootViewController = controller
        self.window?.windowScene = windowScene
        self.window?.makeKeyAndVisible()
    }
    
//    func verifyLogin() {
//        if let _ = UserDefaultsManager.UserInfos.shared.readSesion() {
//            let vc = UINavigationController(rootViewController: HomeViewController())
//            let scenes = UIApplication.shared.connectedScenes
//            let windowScene = scenes.first as? UIWindowScene
//            let window = windowScene?.windows.first
//            window?.rootViewController = vc
//            window?.makeKeyAndVisible()
//        }
//    }
}
