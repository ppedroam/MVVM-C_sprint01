//
//  RRLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Raul Rodrigo on 26/09/22.
//

import Foundation

protocol RRLoginViewModelToViewProtocol  {
    func verifyLogin()
    func validateButton(emailText: String)
    func login(email:String, password: String)
}

protocol RRLoginViewToViewModelProtocol: AnyObject {
    func stateButton(isEnabled: Bool)
    func showAlertDialog()
    func showLoadingFunc()
    func stopLoadingFunc()
    func setLoginError(_ message: String)
}

class RRLoginViewModel {
    weak var delegate: RRLoginViewToViewModelProtocol?
    private let coordinator: RRLoginCoordinating
    private let service: RRLoginRepositoryProtocol
    
    init(service: RRLoginRepositoryProtocol, coordinator: RRLoginCoordinating) {
        self.service = service
        self.coordinator = coordinator
    }
}

extension RRLoginViewModel: RRLoginViewModelToViewProtocol{
    func validateButton(emailText: String) {
        if !emailText.contains(".") ||
            !emailText.contains("@") ||
            emailText.count <= 5 {
            delegate?.stateButton(isEnabled: false)
        } else {
            if let atIndex = emailText.firstIndex(of: "@") {
                let substring = emailText[atIndex...]
                if substring.contains(".") {
                    delegate?.stateButton(isEnabled: true)
                } else {
                    delegate?.stateButton(isEnabled: false)
                }
            } else {
                delegate?.stateButton(isEnabled: false)
            }
        }
    }
    func login(email:String, password: String) {
        let controller = RRLoginViewController(viewModel: self)
        if !ConnectivityManager.shared.isConnected{
            self.delegate?.showAlertDialog()
        }
        self.delegate?.showLoadingFunc()
        let parameters: [String: String] = ["email": email,
                                            "password": password]
        let endpoint = Endpoints.Auth.login
        AF.request(endpoint, method: .get, parameters: parameters, headers: nil) { result in
            DispatchQueue.main.async {
                self.delegate?.stopLoadingFunc()
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let session = try? decoder.decode(Session.self, from: data) {
                        self.coordinator.perform(action: .home)
                        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    } else {
                        Globals.alertMessage(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.", targetVC: controller)
                    }
                case .failure:
                    self.delegate?.setLoginError("E-mail ou senha incorretos")
                    Globals.alertMessage(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.", targetVC: controller)
                }
            }
        }
    }
    
    func verifyLogin()  {
        if service.isLogged() {
            coordinator.perform(action: .home)
        }
    }
    
}



