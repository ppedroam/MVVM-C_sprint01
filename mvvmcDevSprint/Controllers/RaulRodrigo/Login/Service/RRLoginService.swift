//
//  RRLoginService.swift
//  mvvmcDevSprint
//
//  Created by Raul Rodrigo on 05/10/22.
//

import Foundation

protocol RRLoginServicing{
    func login(parameters: [String: String], _ completion: @escaping ((Result<Session, Error>) -> Void))
    func isLogged() -> Bool
}
class RRLoginService: RRLoginServicing{
    let repository: RRLoginRepositoryProtocol
    let apiManager: RRApiManager
    init(repository: RRLoginRepositoryProtocol, apiManager: RRApiManager) {
        self.repository = repository
        self.apiManager = apiManager
    }
    func login(parameters: [String : String], _ completion: @escaping ((Result<Session, Error>) -> Void)) {
        apiManager.request(Endpoints.Auth.login, parameters: nil) { result in
            switch result {
            case .success(let session):
                completion(.success(session))
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    
    func isLogged() -> Bool {
        return repository.isLogged()
    }
    
}
