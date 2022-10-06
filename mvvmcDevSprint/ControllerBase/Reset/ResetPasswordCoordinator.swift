//
//  ResetPasswordCoordinator.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 04/10/22.
//

import UIKit

enum ResetPasswordActions {
    case account
    case contactUs
    case close
    case teste(String)
}

protocol ResetPasswordCoordinating: AnyObject {
    var controller: UIViewController? { get set }
    func perform(action: ResetPasswordActions)
}

class ResetPasswordCoordinator: ResetPasswordCoordinating {
    weak var controller: UIViewController?
    
    func perform(action: ResetPasswordActions) {
        switch action {
        case .account: goToAccount()
        case .contactUs: goToContactUs()
        case .close: controller?.dismiss(animated: true)
        case .teste(let parameters):
            createTesteController(parameters: parameters)
        }
    }
}

private extension ResetPasswordCoordinator {
    func goToAccount() {
        let newVc = CreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        controller?.present(newVc, animated: true)
    }
    
    func goToContactUs() {
        let vc = ContactUsViewController()
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .coverVertical
        controller?.present(vc, animated: true, completion: nil)
    }
    
    func createTesteController(parameters: String) {
        let _ = TesteViewController(parameter: parameters)
    }
}

class TesteViewController {
    private let parametro: String
    
    init(parameter: String) {
        self.parametro = parameter
    }
}
