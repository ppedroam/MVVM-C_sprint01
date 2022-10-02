//
//  ESLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Euclides Medeiros on 02/10/22.
//

import Foundation

protocol ESLoginViewModelProtocol {
    func startResetPasswd()
    func createAccount()
    func showHomeScreen(parameters: [String: String])
    
    var controller: ESLoginViewController? { get set }
    var delegate: ESLoginDelegate? { get set }
}

class ESLoginViewModel: ESLoginViewModelProtocol {
    private let coordinator: ESLoginCoordinator
    var controller: ESLoginViewController?
    weak var delegate: ESLoginDelegate?
    
    init(withCoordinator cood: ESLoginCoordinator) {
        self.coordinator = cood
    }
    
    func startResetPasswd() {
        coordinator.perform(action: .resetPasswd)
    }
    
    func createAccount() {
        coordinator.perform(action: .createAccount)
    }
    
    func showHomeScreen(parameters: [String: String]) {
        if !ConnectivityManager.shared.isConnected {
            coordinator.alertError("Sem conexão", "Conecte-se à internet para tentar novamente")
            return
        }
        
        controller?.showLoading()
        let endpoint = Endpoints.Auth.login
        AF.request(endpoint, method: .get, parameters: parameters, headers: nil) { result in
            DispatchQueue.main.async {
                self.controller?.stopLoading()
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let session = try? decoder.decode(Session.self, from: data) {
                        self.coordinator.perform(action: .goToHome)
                        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    } else {
                        self.coordinator.alertError("Ops..", "Houve um problema, tente novamente mais tarde.")
                    }
                case .failure:
                    self.delegate?.setErrorLogin("E-mail ou senha incorretos")
                    self.coordinator.alertError("Ops..", "Houve um problema, tente novamente mais tarde.")
                }
            }
        }
    }
}
