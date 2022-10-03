//
//  ESLoginServices.swift
//  mvvmcDevSprint
//
//  Created by Euclides Medeiros on 02/10/22.
//


import Foundation

protocol LoginServiceProtocol {
    func fetch(parameters: [String: String], _ completion: @escaping ((Result<Data, Error>) -> Void))
}

class LoginService: LoginServiceProtocol {
    private let service: ServiceManager
    
    required init(_ service: ServiceManager = ServiceManager()) {
        self.service = service
    }
    
    func fetch(parameters: [String: String], _ completion: @escaping ((Result<Data, Error>) -> Void)) {
        let endpoint = Endpoints.Auth.login
        service.request(endpoint, method: .get, parameters: parameters, completion: completion)
    }
    
}
