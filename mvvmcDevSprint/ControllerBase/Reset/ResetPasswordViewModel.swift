//
//  ResetPasswordViewModel.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 28/09/22.
//

import Foundation
import UIKit

protocol ResetPasswordViewModeling {
    func startPasswordRecovering(email: String)
    func goToAccount()
    func goToContactUs()
    func closeScreen()
}

protocol ResetPasswordViewModelDelegate {
    func showErrorState()
    func showNoInternetAlert()
    func showSuccessState()
    func showDefaultAlert2()
}

class ResetPasswordViewModel: ResetPasswordViewModeling {
//    var controller: ResetPasswordViewController?
//    var delegate: ResetPasswordViewModelDelegate?
    var controller: ResetPasswordViewControlling?
    private let coordinator: ResetPasswordCoordinating
    
    private var recoveryEmail = false
    
    init(coordinator: ResetPasswordCoordinating) {
        self.coordinator = coordinator
    }
    
    func startPasswordRecovering(email: String) {
        if recoveryEmail {
            coordinator.perform(action: .close)
            return
        }

        if validateEmail(email: email) {
            callAPI(email: email)
        } else {
            controller?.showErrorState()
//            delegate?.showErrorState()
        }
    }
    
    func goToAccount() {
        coordinator.perform(action: .account)
    }
    
    func goToContactUs() {
        coordinator.perform(action: .contactUs)
    }
    
    func closeScreen() {
        coordinator.perform(action: .close)
    }
}

private extension ResetPasswordViewModel {
    func validateEmail(email: String) -> Bool {
        let isValid = email.contains(".") && email.contains("@") || email.count > 5
        return isValid
    }
    
    func callAPI(email: String) {
        if !ConnectivityManager.shared.isConnected {
            controller?.showNoInternetAlert()
//            delegate?.showNoInternetAlert()
            return
        }
        let emailUser = email.trimmingCharacters(in: .whitespaces)
        let parameters = [
            "email": emailUser
        ]
        startAPICalling(parameters: parameters)
    }
    
    func startAPICalling(parameters: [String: String]) {
        guard let controller = controller else {
            return
        }
        BadNetworkLayer.shared.resetPassword(controller, parameters: parameters) { (success) in
            if success {
                self.recoveryEmail = true
                controller.showSuccessState()
//                self.delegate?.showSuccessState()
            } else {
                controller.showDefaultAlert()
//                self.delegate?.showDefaultAlert2()
                //coordinator.perform(action: .teste("teste"))
            }
        }
    }
}


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
    var controller: UIViewController?
    
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

