//
//  LoginCoordinator.swift
//  mvvmcDevSprint
//
//  Created by Euclides Medeiros on 26/09/22.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginStart = ESLoginViewController()
        navigationController.pushViewController(loginStart, animated: true)
    }
}
