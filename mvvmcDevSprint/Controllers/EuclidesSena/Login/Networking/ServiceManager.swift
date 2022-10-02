//
//  ServiceManager.swift
//  mvvmcDevSprint
//
//  Created by Euclides Medeiros on 02/10/22.
//

import Foundation

struct ServiceManager {
    enum Method {
        case get
        case post
    }
    
    func request(_ url: String, method: Method, parameters: [String: String]?, headers: [String: String]? = nil, completion: @escaping ((Result<Data, Error>) -> Void)) {
        switch url {
        case Endpoints.Auth.login:
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

        case Endpoints.contactUs:
            let contacUsModel = ContactUsModel(whatsapp: "37998988822",
                                               phone: "0800-616161",
                                               mail: "cleanCode@devPass.com")
            let data = try? JSONEncoder().encode(contacUsModel)
            if let data = data {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceManagerErros.invalidData))
            }

        case Endpoints.sendMessage:
            if let data = "sucesso".data(using: .utf8) {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceManagerErros.invalidData))
            }

        case Endpoints.Auth.createUser:
            let session = Session(id: UUID.init().uuidString, token: UUID.init().uuidString)
            let data = try? JSONEncoder().encode(session)
            if let data = data {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceManagerErros.invalidData))
            }
            
        case Endpoints.getLagostaInfos:
            let infos = LagostaInfos.create()
            let data = try? JSONEncoder().encode(infos)
            if let data = data {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    completion(.success(data))
                }
            } else {
                completion(.failure(ServiceManagerErros.invalidData))
            }

        default:
            completion(.failure(ServiceManagerErros.failure))
        }
    }
}

enum ServiceManagerErros: Error {
    case invalidData
    case failure
    case invalidCredentials
}
