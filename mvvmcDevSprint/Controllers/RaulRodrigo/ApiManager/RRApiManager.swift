//
//  ApiManager.swift
//  mvvmcDevSprint
//
//  Created by Raul Rodrigo on 06/10/22.
//

import Foundation

struct RRApiManager {
    func request(_ url: String, parameters: [String: String]?, headers: [String: String]? = nil, completion: @escaping ((Result<Session, Error>) -> Void)) {
        switch url {
        case Endpoints.Auth.login:
            if let email = parameters?["email"],
               let password = parameters?["password"],
               email == "mvvmc@devpass.com" && password == "Abcde1" {
                
                AF.request(url, method: .get, parameters: parameters, headers: nil) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            let decoder = JSONDecoder()
                            if let session = try? decoder.decode(Session.self, from: data) {
                                completion(.success(session))
                            } else {
                                completion(.failure(RRApiManagerError.decodeError))
                            }
                        case .failure:
                            completion(.failure(RRApiManagerError.requestError))
                        }
                    }
                }
            } else {
                completion(.failure(RRApiManagerError.invalidData))
            }
        default:
            completion(.failure(RRApiManagerError.requestError))
        }
    }
    
}

enum RRApiManagerError: Error {
    case decodeError
    case requestError
    case invalidData
}
