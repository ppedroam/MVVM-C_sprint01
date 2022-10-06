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
    weak var controller: ResetPasswordViewControlling?
    private let coordinator: ResetPasswordCoordinating
    private let service: ResetPasswordServicing
    
    private var recoveryEmail = false
    
    init(
        coordinator: ResetPasswordCoordinating,
        service: ResetPasswordServicing
    ) {
        self.coordinator = coordinator
        self.service = service
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
        controller?.showSuccessState()
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
        startAPICalling(email: email)
    }
    
    func startAPICalling(email: String) {
        guard let controller = controller else {
            return
        }
        let emailUser = email.trimmingCharacters(in: .whitespaces)
        service.tryResetPassword(email: emailUser) { [weak self] result in
            switch result {
            case .success:
                self?.recoveryEmail = true
                controller.showSuccessState()
            case .failure(let error):
                print(error.localizedDescription)
                controller.showSuccessState()
            }
        }
    }
}
