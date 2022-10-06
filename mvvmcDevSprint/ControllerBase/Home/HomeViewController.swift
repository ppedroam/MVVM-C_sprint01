//
//  HomeViewController.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 22/09/22.
//

import UIKit

class HomeViewController: UIViewController {
    var lastController: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickLogout(_ sender: Any) {
        let loginController = LoginViewController()
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        UserDefaultsManager.UserInfos.shared.delete()
        
        let overlayView = UIScreen.main.snapshotView(afterScreenUpdates: false)
        loginController.view.addSubview(overlayView)
        window?.rootViewController = loginController

        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCrossDissolve, animations: {
            overlayView.alpha = 0
        }, completion: { finished in
            overlayView.removeFromSuperview()
        })
    }
}
