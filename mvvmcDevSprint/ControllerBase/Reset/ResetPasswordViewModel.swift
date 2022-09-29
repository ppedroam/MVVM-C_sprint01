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
}
