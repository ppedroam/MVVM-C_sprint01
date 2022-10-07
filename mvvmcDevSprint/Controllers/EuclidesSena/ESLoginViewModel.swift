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
    func verifyLogin()
    
    var delegate: ESLoginDelegate? { get set }
    var showPasswordLogin: Bool { get set }
    var requestErrorInLogin: Bool { get set }
}

class ESLoginViewModel: ESLoginViewModelProtocol {
    private let coordinator: ESLoginCoordinator
    private let service: LoginServiceProtocol
    
    var showPasswordLogin = true
    var requestErrorInLogin = false
    
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
    
    func verifyLogin() {
        coordinator.perform(action: .verifyLogin)
    }
    
    func showHomeScreen(parameters: [String: String]) {
        if !ConnectivityManager.shared.isConnected {
            self.coordinator.perform(action: .alert("Sem conexão", "Conecte-se à internet para tentar novamente"))
            return
        }
        
        delegate?.showLoadingScreen()
        service.login(parameters: parameters) { [weak self] result in
            guard let self = self else{ return }
            DispatchQueue.main.async {
                self.delegate?.stopLoadingScreen()
                self.handleShowHomeResponse(with: result)
            }
        }
    }
    
    func handleShowHomeResponse(with result: Result<Session, Error>) {
        switch result {
        case .success(let session):
            UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
            coordinator.perform(action: .goToHome)
        case .failure:
            delegate?.setErrorLogin("E-mail ou senha incorretos")
            coordinator.perform(action: .alert("Ops..", "Houve um problema, tente novamente mais tarde."))
        }
    }
}
