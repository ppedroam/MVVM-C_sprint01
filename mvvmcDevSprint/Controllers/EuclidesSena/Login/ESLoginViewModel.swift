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
    private let service: LoginServiceProtocol
    
    var controller: ESLoginViewController?
    weak var delegate: ESLoginDelegate?
    
    init(withCoordinator cood: ESLoginCoordinator, _ service: LoginServiceProtocol = LoginService()) {
        self.coordinator = cood
        self.service = service
    }
    
    func startResetPasswd() {
        coordinator.perform(action: .resetPasswd)
    }
    
    func createAccount() {
        coordinator.perform(action: .createAccount)
    }
    
    func showHomeScreen(parameters: [String: String]) {
        if !ConnectivityManager.shared.isConnected {
            self.coordinator.perform(action: .alert("Sem conexão", "Conecte-se à internet para tentar novamente"))
            return
        }
        
        controller?.showLoading()
        service.fetch(parameters: parameters) { result in
            DispatchQueue.main.async {
                self.controller?.stopLoading()
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let session = try? decoder.decode(Session.self, from: data) {
                        self.coordinator.perform(action: .goToHome)
                        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    } else {
                        self.coordinator.perform(action: .alert("Ops..", "Houve um problema, tente novamente mais tarde."))
                    }
                case .failure:
                    self.delegate?.setErrorLogin("E-mail ou senha incorretos")
                    self.coordinator.perform(action: .alert("Ops..", "Houve um problema, tente novamente mais tarde."))
                }
            }
        }
    }
}
