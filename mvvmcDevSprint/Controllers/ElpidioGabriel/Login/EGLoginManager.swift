//
//  EGLoginManager.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Aragao on 07/10/22.
//

import Foundation

struct EGLoginManager {
    enum Method {
        case get
        case post
    }
    
    func request(_ url: String, method: Method, parameters: [String: String]?, headers: [String: String]? = nil, completion: @escaping ((Result<Data, Error>) -> Void)) {
            if url == Endpoints.Auth.login {
            if let email = parameters?["email"],
               let password = parameters?["password"],
               email == "mvvmc@devpass.com" && password == "Abcde1" {

                let session = Session(id: UUID.init().uuidString, token: UUID.init().uuidString)
                let data = try? JSONEncoder().encode(session)
                if let data = data {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        completion(.success(data))
                    }
                } else {
                    completion(.failure(ServiceManagerErros.invalidData))
                }
            } else {
                completion(.failure(ServiceManagerErros.invalidData))
            }
            completion(.failure(ServiceManagerErros.failure))
        }
    }
}

enum EGManagerErros: Error {
    case invalidData
    case failure
    case invalidCredentials
}


