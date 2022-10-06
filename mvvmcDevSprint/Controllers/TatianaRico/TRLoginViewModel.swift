//
//  TRLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Tatiana Rico on 29/09/22.
//

import Foundation
import UIKit

class TRLoginViewModel {
    var vc: TRLoginViewController? = nil
    var errorInLogin = false
    
    let coordinator = TRLoginCoordinator()
    
    func verifyLogin() {
        coordinator.verifyLogin()
    }
    
    func isEmailValid(email: String) -> Bool {
       guard let atIndex  = email.firstIndex(of: "@") else { return false }
        let emailHasDot = email.contains(".")
        let emailHasAt = email.contains("@")
        let emailIsHigherOrEqualToFive = email.count >= 5
        let substring = email[atIndex...]
        let substringHasDot = substring.contains(".")
        
        let isEmailValid = emailHasDot && emailHasAt && emailIsHigherOrEqualToFive && substringHasDot
        
        if  isEmailValid {
            return true
        } else {
            return false
        }
}
    
    func requestScreenLogin(email: String, password: String) {
        
        let parameters: [String: String] = ["email": email,
                                            "password": password]
        let endpoint = Endpoints.Auth.login
        
        AF.request(endpoint, method: .get, parameters: parameters, headers: nil) { result in
            DispatchQueue.main.async {
                self.vc?.stopLoading()
                
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let session = try? decoder.decode(Session.self, from: data) {
                        self.vc?.goToHome()
                        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    } else {
                        self.vc?.globalsAlerts(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.")
                    }
                case .failure:
                    self.errorInLogin = true
                    self.vc?.setErrorLogin("E-mail ou senha incorretos")
                    self.vc?.globalsAlerts(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.")
                }
            }
        }
    }
    
    func goToResetPassword() {
        self.coordinator.vc = vc
        coordinator.goToResetPassword()
    }
    
    func goToCreatAccount() {
        self.coordinator.vc = vc
        coordinator.goToCreatAccount()
    }
    
    private func alertConexao(title: String, message: String) {
        self.coordinator.vc = vc
        coordinator.alertConexaoStates(title: title, message: message)
    }
    
    func noConnectedInternet() {
        if !ConnectivityManager.shared.isConnected {
            self.alertConexao(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente")
        }
    }
    
    func resetErrorLogin(_ textFieldEmail: UITextField, textFieldPassword: UITextField) {
        if errorInLogin {
            textFieldEmail.setEditingColor()
            textFieldPassword.setDefaultColor()
        } else {
            textFieldEmail.setDefaultColor()
            textFieldPassword.setDefaultColor()
        }
    }
}
