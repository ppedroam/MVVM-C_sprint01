//
//  ESLoginServices.swift
//  mvvmcDevSprint
//
//  Created by Euclides Medeiros on 02/10/22.
//


import Foundation

protocol LoginServiceProtocol {
    func fetch(parameters: [String: String], _ completion: @escaping ((Result<Data, Error>) -> Void))
    func decodeResponse(data: Data) -> Bool
}

class ESLoginService: LoginServiceProtocol {
    private let service: ESServiceManager
    
    required init(_ service: ESServiceManager = ESServiceManager()) {
        self.service = service
    }
    
    func fetch(parameters: [String: String], _ completion: @escaping ((Result<Data, Error>) -> Void)) {
        let endpoint = Endpoints.Auth.login
        service.request(endpoint, method: .get, parameters: parameters, completion: completion)
    }
    
}

extension ESLoginService {
    func decodeResponse(data: Data) -> Bool {
        let decoder = JSONDecoder()
        if let session = try? decoder.decode(Session.self, from: data) {
            UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
            return true
        }
        return false
    }
    
}
