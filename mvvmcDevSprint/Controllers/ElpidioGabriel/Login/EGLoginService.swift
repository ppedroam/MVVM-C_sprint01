//
//  EGLoginService.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Aragao on 07/10/22.
//

import Foundation

protocol EGLoginServiceProtocol {
    func login(parameters: [String: String], _ completion: @escaping ((Result<Session, Error>) -> Void))
    func isLogged() -> Bool
}

class EGLoginService: EGLoginServiceProtocol {
    
    private let serviceManager: EGLoginManager
    
    init(serviceManager: EGLoginManager = EGLoginManager()) {
        self.serviceManager = serviceManager
    }
    
    func login(parameters: [String: String], _ completion: @escaping ((Result<Session, Error>) -> Void)){
        serviceManager.request(Endpoints.Auth.login, method: .get, parameters: parameters, completion: { response in
            switch response {
            case .success(let data):
                let decoder = JSONDecoder()
                if let session = try? decoder.decode(Session.self, from: data) {
                    completion(.success(session))
                } else {
                    completion(.failure(ServiceError.decoding))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func isLogged() -> Bool {
        return UserDefaultsManager.UserInfos.shared.readSesion() != nil ? true : false 
    }
    
}
