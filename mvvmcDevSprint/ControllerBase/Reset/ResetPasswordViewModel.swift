//
//  ResetPasswordViewModel.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 28/09/22.
//

import Foundation
import UIKit


class ResetPasswordViewModel {
    var controller: ResetPasswordViewController?
    let coordinator = ResetPasswordCoordinator()
    
    func validateEmail(email: String) -> Bool {
        let isValid = email.contains(".") && email.contains("@") || email.count > 5
        return isValid
    }
    
    func callAPI(email: String) {
        if !ConnectivityManager.shared.isConnected {
            controller?.showNoInternetAlert()
            return
        }
        let emailUser = email.trimmingCharacters(in: .whitespaces)
        let parameters = [
            "email": emailUser
        ]
        guard let controller = controller else {
            return
        }
        BadNetworkLayer.shared.resetPassword(controller, parameters: parameters) { (success) in
            if success {
                controller.showSuccessState()
            } else {
                controller.showDefaultAlert()
            }
        }
    }
    
    func goToAccount() {
        coordinator.controller = controller
        coordinator.perform(action: .account)
    }
    
    func goToContactUs() {
        coordinator.controller = controller
        coordinator.perform(action: .contactUs)
    }
    
    func closeScreen() {
        coordinator.perform(action: .close)
    }
}

enum ResetPasswordActions {
    case account
    case contactUs
    case close
}

class ResetPasswordCoordinator {
    var controller: UIViewController?
    
    func perform(action: ResetPasswordActions) {
        switch action {
        case .account: goToAccount()
        case .contactUs: goToContactUs()
        case .close: controller?.dismiss(animated: true)
        }
    }
    
    private func goToAccount() {
        let newVc = CreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        controller?.present(newVc, animated: true)
    }
    
    private func goToContactUs() {
        let vc = ContactUsViewController()
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .coverVertical
        controller?.present(vc, animated: true, completion: nil)
    }
}
