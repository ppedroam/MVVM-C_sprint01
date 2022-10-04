//
//  ESLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Euclides Medeiros on 02/10/22.
//

import Foundation

protocol ESLoginDelegate: AnyObject {
    func setErrorLogin(_ message: String)
    func showLoadingScreen()
    func stopLoadingScreen()
}

protocol ESLoginViewModelProtocol {
    func startResetPasswd()
    func createAccount()
    func showHomeScreen(parameters: [String: String])

    var delegate: ESLoginDelegate? { get set }
    var showPassword: Bool { get set }
    var errorInLogin: Bool { get set }
}

class ESLoginViewModel: ESLoginViewModelProtocol {
    private let coordinator: ESLoginCoordinator
    private let service: LoginServiceProtocol
    
    var showPassword = true
    var errorInLogin = false

    weak var delegate: ESLoginDelegate?
    
    init(withCoordinator cood: ESLoginCoordinator, _ service: LoginServiceProtocol = ESLoginService()) {
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
        
        delegate?.showLoadingScreen()
        service.fetch(parameters: parameters) { result in
            DispatchQueue.main.async {
                self.delegate?.stopLoadingScreen()
                switch result {
                case .success(let data):
                    let decoder = self.service.decodeResponse(data: data)
                    decoder ? self.coordinator.perform(action: .goToHome) : self.coordinator.perform(action: .alert("Ops..", "Houve um problema, tente novamente mais tarde."))
                case .failure:
                    self.delegate?.setErrorLogin("E-mail ou senha incorretos")
                    self.coordinator.perform(action: .alert("Ops..", "Houve um problema, tente novamente mais tarde."))
                }
            }
        }
    }
}
