//
//  DSLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by CAF on 28/09/22.
//

import Foundation

protocol DSLoginViewModelDelegate {
    func initLoading()
    func pauseLoading()
    func alertMessage(title: String, message: String)
    func nextViewController()
    func showErrorLogin(_ message: String)
}

class DSLoginViewModel {
    
    public var delegate: DSLoginViewModelDelegate?
    
    // MARK: Login Validation
    
    public func verifyLogin(email: String, password: String) {
        if !isNetworkConnected() {
            delegate?.alertMessage(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente")
            return
        }
        
        delegate?.initLoading()
        
        let parameters = ["email": email, "password": password]
        return makeLoginRequest(parameters){ result in
            self.delegate?.pauseLoading()
            switch result {
            case .success:
                self.delegate?.nextViewController()
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
    
    private func sendAltertErrorMessage(){
        self.delegate?.alertMessage(title: "Ops...", message: "Houve um problema, tente novamente mais tarde.")
    }
    
    private func makeLoginRequest(_ parameters: [String: String], completion: @escaping ((EmailResponse) -> Void)) {
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
    
    private func isNetworkConnected() -> Bool {
        return ConnectivityManager.shared.isConnected
    }
    
    // MARK: E-mail validation
    
    public func isValidEmail(_ email: String) -> Bool {
        return isValidFormatEmail(email) && isValidEmailDomain(email)
    }
    
    private func isValidFormatEmail(_ email: String) -> Bool {
        return email.contains(".") ||
            email.contains("@") ||
            email.count > 5
    }
    
    private func isValidEmailDomain(_ email: String) -> Bool {
        if let domain = getEmailDomain(email){
            return domain.contains(".")
        }
        return false
    }
    
    private func getEmailDomain(_ email: String) -> Substring? {
        if let atIndex = email.firstIndex(of: "@") {
            let domain = email[atIndex...]
            return domain
        }
        return nil
    }
}


