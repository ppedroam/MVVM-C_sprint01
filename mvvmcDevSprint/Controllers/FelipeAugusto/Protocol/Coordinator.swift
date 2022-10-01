//
//  CoordinatorProtocol.swift
//  mvvmcDevSprint
//
//  Created by FELIPE AUGUSTO SILVA on 30/09/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }

    func start()
}

protocol Coordinating {
    func openCreateAccount()
    func openContactUs()
    func openForgotPassword()
}
