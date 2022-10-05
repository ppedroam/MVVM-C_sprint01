//
//  GPLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 26/09/22.
//

import Foundation
import UIKit

protocol GPLoginViewModelProtocol {
    var hasError: Bool { get }
    var showPasswordState: Bool { get }
    
    func validateEmail(email: String) -> Bool
    func secondValidateEmail(email: String) -> Bool
    func managerIsConected() -> Bool
    func loginAuthentication(email: String?, password: String?) -> Bool
}


class GPLoginViewModel: GPLoginViewModelProtocol {
    
    var hasError: Bool = false
    var showPasswordState = true
    
    init() {
        
    }
    
    func loginAuthentication(email: String?, password: String?) -> Bool {
        guard let email = email else { return false }
        guard let password = password else { return false }
        let parameters: [String: String] = ["email": email,
                                            "password": password]
        let endPoint = Endpoints.Auth.login
        
        authAuthentication(endPoint: endPoint, method: .get, parameters: parameters) { result in
            switch result {
            case .success(_):
                self.hasError = false
            case .failure(_):
                self.hasError = true
            }
        }
        return hasError
    }

    func validateEmail(email: String) -> Bool {
        let validate = email.contains(".") && email.contains("@") || email.count <= 5
        return validate
    }
    
    func managerIsConected() -> Bool {
        return ConnectivityManager.shared.isConnected
    }
    
    private func authAuthentication(endPoint: String, method: AF.Methods, parameters: [String : String]?, completion: @escaping ((Result<Data, Error>) -> Void)) {
        AF.request(endPoint, method: .get, parameters: parameters, headers: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let session = try? decoder.decode(Session.self, from: data) {
                        self.hasError = false
                        let vc = UINavigationController(rootViewController: HomeViewController())
                        let scenes = UIApplication.shared.connectedScenes
                        let windowScene = scenes.first as? UIWindowScene
                        let window = windowScene?.windows.first
                        window?.rootViewController = vc
                        window?.makeKeyAndVisible()
                        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    } else {
                        self.hasError = true
                    }
                case .failure(let error):
                    print("error api: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func secondValidateEmail(email: String) -> Bool {
        if let atIndex = email.firstIndex(of: "@") {
            let substring = email[atIndex...]
            if substring.contains(".") {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
