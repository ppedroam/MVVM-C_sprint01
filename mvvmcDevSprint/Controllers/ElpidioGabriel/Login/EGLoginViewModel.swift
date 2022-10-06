//
//  EGLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Aragao on 28/09/22.
//

import Foundation

protocol EGLoginViewModelDelegate {
    func noConnectionAlert()
    func showLoadingFunction()
    func stopLoadingFunction()
    func tryAgainAlert()
    func loginErrorMessage()
    func isButtonEnable(_ status: Bool)
}

protocol EGLoginViewModelProtocol {
    func verifyLogin()
    func isLogged(emailText: String, passwordText: String)
    func validateButton(emailText: String)
    func goToCreateAccount()
    func goToResetPassword()
    func goToHomeView()
}

final class EGLoginViewModel: EGLoginViewModelProtocol  {
    var delegate: EGLoginViewModelDelegate?
    
    let coordinator: EGLoginCoordinatorProtocol
    
    init(delegate: EGLoginViewModelDelegate? = nil, coordinator: EGLoginCoordinatorProtocol) {
        self.delegate = delegate
        self.coordinator = coordinator
    }
    
    func verifyLogin() {
        if let _ = UserDefaultsManager.UserInfos.shared.readSesion() {
            coordinator.goToHomeView()
        }
    }
    
    func isLogged(emailText: String, passwordText: String) {
        if !ConnectivityManager.shared.isConnected {
            delegate?.noConnectionAlert()
        } else {
            delegate?.showLoadingFunction()
            let parameters: [String: String] = ["email": emailText, "password": passwordText]
            let endpoint = Endpoints.Auth.login
            AF.request(endpoint, method: .get, parameters: parameters, headers: nil) { result in
                DispatchQueue.main.async {
                    self.delegate?.stopLoadingFunction()
                    switch result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        if let session = try? decoder.decode(Session.self, from: data) {
                            self.coordinator.goToHomeView()
                            UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                        } else {
                            self.delegate?.tryAgainAlert()
                        }
                    case .failure:
                        self.delegate?.loginErrorMessage()
                        self.delegate?.tryAgainAlert()
                    }
                }
            }
        }
    }
    
    func validateButton(emailText: String) {
        if !emailText.contains(".") ||
            !emailText.contains("@") ||
            emailText.count <= 5 {
            self.delegate?.isButtonEnable(false)
        } else {
            if let atIndex = emailText.firstIndex(of: "@") {
                let substring = emailText[atIndex...]
                if substring.contains(".") {
                    self.delegate?.isButtonEnable(true)
                } else {
                    self.delegate?.isButtonEnable(false)
                }
            } else {
                self.delegate?.isButtonEnable(false)
            }
        }
    }
    
    func goToCreateAccount() {
        coordinator.goToCreateAccount()
    }
    
    func goToResetPassword() {
        coordinator.goToResetPassword()
    }
    
    func goToHomeView() {
        
    }
}
