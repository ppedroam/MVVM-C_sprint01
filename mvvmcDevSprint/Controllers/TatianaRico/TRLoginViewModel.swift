//
//  TRLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Tatiana Rico on 29/09/22.
//

import Foundation
import UIKit

protocol TRLoginViewModeling {
    func verifyLogin()
    func isEmailValid(email: String) -> Bool
    func goToResetPassword()
    func startLogin(email: String, password: String)
    func goToCreatAccount()
    var errorInLogin: Bool { get }
    func noConnectedInternet()
}

class TRLoginViewModel: TRLoginViewModeling {
    var vc: TRLoginViewController? = nil
    var errorInLogin = false
    let coordinator: TRLoginCoordinator?
    let service: TRLogincServicing
    
    init(coordinator: TRLoginCoordinator, service: TRService) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func verifyLogin() {
        coordinator?.verifyLogin()
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
    
    func startLogin(email: String, password: String) {
        service.tryLogin(email: email, password: password) { [ weak self ] result in
            self?.vc?.stopLoading()
            DispatchQueue.main.async {
                self?.handleLoginResponse(with: result)
            }
        }
    }
    
    func handleLoginResponse(with result: Result<Session, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                self.vc?.goToHome()
                UserDefaultsManager.UserInfos.shared.save(session: data, user: nil)
            case .failure(_):
                self.errorInLogin = false
                self.vc?.setErrorLogin("E-mail ou senha incorretos")
                self.vc?.globalsAlerts(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.")
            }
        }
    }
    
    func goToResetPassword() {
        self.coordinator?.controller = vc
        coordinator?.perform(action: .resetPassword)
    }
    
    func goToCreatAccount() {
        self.coordinator?.controller = vc
        coordinator?.perform(action: .createAccount)
    }
    
    func noConnectedInternet() {
        if !ConnectivityManager.shared.isConnected {
            self.alertConexao(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente")
        }
    }
}

private extension TRLoginViewModel {
    func alertConexao(title: String, message: String) {
        self.coordinator?.controller = vc
        coordinator?.alertConexaoStates(title: title, message: message)
    }
}
