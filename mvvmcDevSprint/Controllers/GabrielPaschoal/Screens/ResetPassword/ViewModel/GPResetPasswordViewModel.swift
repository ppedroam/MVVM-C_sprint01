//
//  GPResetPasswordViewModel.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 28/09/22.
//

import Foundation
import UIKit

protocol GPResetPasswordViewModelProtocol {
    func validateForm(email: String) -> Bool
    func resetPassword(vc: UIViewController, emailUser: String, completionHandler: @escaping (Bool) -> Void)
}

class GPResetPasswordViewModel: GPResetPasswordViewModelProtocol {
    
    func validateForm(email: String) -> Bool {
        let validate = email.isEmpty || !email.contains(".") &&
        !email.contains("@") || email.count <= 5
        return validate
    }
    
    func resetPassword(vc: UIViewController, emailUser: String, completionHandler: @escaping (Bool) -> Void) {
        let parameters = [
            "email": emailUser
        ]
        resetPasswordService(vc: vc, parameters: parameters, completionHandler: completionHandler)
    }
    
    func resetPasswordService(vc: UIViewController, parameters: [String : String], completionHandler: @escaping (Bool) -> Void) {
        BadNetworkLayer.shared.resetPassword(vc, parameters: parameters, completionHandler: completionHandler)
    }
    
}
