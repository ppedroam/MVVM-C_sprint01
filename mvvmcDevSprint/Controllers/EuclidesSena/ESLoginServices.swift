//
//  ESLoginServices.swift
//  mvvmcDevSprint
//
//  Created by Euclides Medeiros on 02/10/22.
//


import Foundation

protocol LoginServiceProtocol {
    func login(parameters: [String: String], _ completion: @escaping ((Result<Session, Error>) -> Void))
}

class ESLoginService: LoginServiceProtocol {
    private let service: ESServiceManager
    
    required init(_ service: ESServiceManager = ESServiceManager()) {
        self.service = service
    }
    
    func login(parameters: [String: String], _ completion: @escaping ((Result<Session, Error>) -> Void)) {
        let endpoint = Endpoints.Auth.login
        service.request(endpoint, method: .get, parameters: parameters, completion: { response in
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
    
}
