//
//  DSLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by CAF on 28/09/22.
//

import Foundation

protocol DSLoginViewModelDelegate {
    func startLoading()
    func pauseLoading()
    func alertMessage(title: String, message: String)
    func showErrorLogin(_ message: String)
    func enableButton()
    func disableButton()
}

class DSLoginViewModel {
    
    public var delegate: DSLoginViewModelDelegate?
    var coordinator: DSLoginCoordinator?
    
    init(coordinator: DSLoginCoordinator){
        self.coordinator = coordinator
    }
        
    func verifyLogin(email: String, password: String) {
        if !isNetworkConnected() {
            delegate?.alertMessage(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente")
            return
        }
        
        delegate?.startLoading()
        
        let parameters = ["email": email, "password": password]
        return makeLoginRequest(parameters){ [self] result in
            self.delegate?.pauseLoading()
            switch result {
            case .success:
                goToHome()
                break
            case .invalidCredentials:
                self.delegate?.showErrorLogin("E-mail ou senha incorretos")
                self.sendAltertErrorMessage()
                break
            case .failure:
                self.sendAltertErrorMessage()
                break
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return isValidFormatEmail(email) && isValidEmailDomain(email)
    }
    

    func verifySession() {
        if let _ = UserDefaultsManager.UserInfos.shared.readSesion(){
            goToHome()
        }
    }
    
    func validateButton(_ email: String) {
        if isValidEmail(email){
            delegate?.enableButton()
        }else{
            delegate?.disableButton()
        }
    }
    
    // MARK: Coordinator
    
    func goToResetPassword() {
        coordinator?.perform(action: .resetPassword)
    }
    
    func goToCreateAccount(){
        coordinator?.perform(action: .createAccount)
    }
    
    func goToHome(){
        coordinator?.perform(action: .home)
    }
}

private extension DSLoginViewModel {
    
    func isNetworkConnected() -> Bool {
        return ConnectivityManager.shared.isConnected
    }
    
    func isValidFormatEmail(_ email: String) -> Bool {
        return email.contains(".") &&
            email.contains("@") &&
            email.count > 5
    }
    
    func isValidEmailDomain(_ email: String) -> Bool {
        if let domain = getEmailDomain(email){
            return domain.contains(".")
        }
        return false
    }
    
    func getEmailDomain(_ email: String) -> Substring? {
        if let atIndex = email.firstIndex(of: "@") {
            let domain = email[atIndex...]
            return domain
        }
        return nil
    }
    
    func makeLoginRequest(_ parameters: [String: String], completion: @escaping ((DSEmailResponse) -> Void)) {
        let endpoint = Endpoints.Auth.login
        AF.request(endpoint, method: .get, parameters: parameters, headers: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let session = try? decoder.decode(Session.self, from: data) {
                        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                        completion(.success)
                    } else {
                        completion(.failure)
                    }
                case .failure:
                    completion(.invalidCredentials)
                }
            }
        }
    }
    
    func sendAltertErrorMessage(){
        self.delegate?.alertMessage(title: "Ops...", message: "Houve um problema, tente novamente mais tarde.")
    }
}


