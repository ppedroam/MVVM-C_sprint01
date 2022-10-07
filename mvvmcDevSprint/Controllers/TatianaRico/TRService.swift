//
//  TRService.swift
//  mvvmcDevSprint
//
//  Created by Tatiana Rico on 07/10/22.
//

import Foundation

protocol TRLogincServicing {
    func tryLogin(email: String, password: String, completion: @escaping (Result<Session, Error>)->Void)
}

struct TRService: TRLogincServicing {
    func tryLogin(email: String, password: String, completion: @escaping (Result<Session, Error>)->Void) {
        let params = ["email": email, "password": password] as Dictionary<String, String>
        
        var request = URLRequest(url: URL(string: "www.aplicandoCleanCode.muito.foda/login")!)
        request.httpMethod = "GET"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let _ = error {
                completion(.failure(ServiceError.failure))
            }
            
            let decoder = JSONDecoder()
            if let data = data,
               let json = try? decoder.decode(Session.self, from: data) {
                completion(.success(json))
            } else {
                completion(.failure(ServiceError.decoding))
            }
            
        })
        task.resume()
    }
}

