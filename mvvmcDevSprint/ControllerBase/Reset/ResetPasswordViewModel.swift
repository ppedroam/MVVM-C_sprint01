//
//  ResetPasswordViewModel.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 28/09/22.
//

import Foundation
import UIKit

protocol ResetPasswordViewModeling {
    func startPasswordRecovering(with email: String)
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
    
    private var didRecoveryEmail = false
    
    init(
        coordinator: ResetPasswordCoordinating,
        service: ResetPasswordServicing
    ) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func startPasswordRecovering(with email: String) {
        if didRecoveryEmail {
            coordinator.perform(action: .close)
        } else {
            tryResetPasswordIfEmailIsValid(with: email)
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
    func isEmailValid(for email: String) -> Bool {
        let isValid = email.contains(".") && email.contains("@") || email.count > 5
        return isValid
    }
    
    func tryResetPasswordIfEmailIsValid(with email: String) {
        if isEmailValid(for: email) {
            tryResetPasswordIfConnected(with: email)
        } else {
            controller?.showErrorState()
//            delegate?.showErrorState()
        }
    }
    
    func tryResetPasswordIfConnected(with email: String) {
        if !ConnectivityManager.shared.isConnected {
            controller?.showNoInternetAlert()
            //            delegate?.showNoInternetAlert()
        } else {
            startPasswordReseting(with: email)
        }
    }
    
    func startPasswordReseting(with email: String) {
        guard let _ = controller else { return }
        let emailUser = email.trimmingCharacters(in: .whitespaces)
        service.tryResetPassword(email: emailUser) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleResetPasswordResponse(with: result)
            }
        }
    }
    
    func handleResetPasswordResponse(with result: Result<Bool, Error>) {
        switch result {
        case .success:
            self.didSuccedPasswordRecovering()
        case .failure(let error):
            print(error.localizedDescription)
            controller?.showSuccessState()
        }
    }
    
    func didSuccedPasswordRecovering() {
        self.didRecoveryEmail = true
        controller?.showSuccessState()
    }
}
