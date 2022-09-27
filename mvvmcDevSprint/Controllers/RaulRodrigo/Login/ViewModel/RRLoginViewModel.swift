//
//  RRLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Raul Rodrigo on 26/09/22.
//

import Foundation
import UIKit

protocol RRLoginViewModelProtocol {
    func verifyLogin() -> Bool
    func login(email:String, password: String,targetVC: UIViewController)
    func initialConstant(initial: CGFloat)
}

class RRLoginViewModel {
    
    var vc: RRLoginViewControllerProtocol?
    var service: RRLoginServiceProtocol?
    var initialConstant: CGFloat = 0
    let defaultSpacing: CGFloat = 100
    var yVariation: CGFloat = 0
    var textFieldIsMoving = false
    var showPassword = true
    var errorInLogin = false
    
}

extension RRLoginViewModel: RRLoginViewModelProtocol{
    func initialConstant(initial: CGFloat) {
        initialConstant = initial
    }
    
    func login(email:String, password: String, targetVC: UIViewController) {
        let parameters: [String: String] = ["email": email,
                                            "password": password]
        let endpoint = Endpoints.Auth.login
        AF.request(endpoint, method: .get, parameters: parameters, headers: nil) { result in
            DispatchQueue.main.async {
                self.vc?.stopLoadingFunc()
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let session = try? decoder.decode(Session.self, from: data) {
                        self.vc?.goToHome()
                        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    } else {
                        Globals.alertMessage(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.", targetVC: targetVC)
                    }
                case .failure:
                    self.vc?.setLoginError()
                    Globals.alertMessage(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.", targetVC: targetVC)
                }
            }
        }
    }
    
   
    func verifyLogin() -> Bool {
        return service?.isLogged() ?? false
    }
    
}


