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
    private let service: RRLoginServicing
    
    init(service: RRLoginServicing, coordinator: RRLoginCoordinating) {
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
            return
        }
        self.delegate?.showLoadingFunc()
        let parameters: [String: String] = ["email": email,
                                            "password": password]
        
        DispatchQueue.main.async {
            self.delegate?.stopLoadingFunc()
            self.service.login(parameters: parameters) { result in
                switch result{
                case .success(let session):
                    
                    self.coordinator.perform(action: .home)
                    UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    
                case .failure(let error):
                    if error as? RRApiManagerError == RRApiManagerError.decodeError {
                        Globals.alertMessage(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.", targetVC: controller)
                    } else {
                        self.delegate?.setLoginError("E-mail ou senha incorretos")
                        Globals.alertMessage(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.", targetVC: controller)
                    }
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
    
    
    
