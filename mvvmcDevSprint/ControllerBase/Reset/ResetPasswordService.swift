//
//  ResetPasswordService.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 04/10/22.
//

import Foundation


protocol ResetPasswordServicing {
    func tryResetPassword(email: String, completion: @escaping (Result<Bool, Error>)->Void)
}

struct ResetPasswordService: ResetPasswordServicing {
    func tryResetPassword(email: String, completion: @escaping (Result<Bool, Error>)->Void) {
        let params = ["email": email] as Dictionary<String, String>

        var request = URLRequest(url: URL(string: "http://localhost:8080/api/resetPassword")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let _ = error {
                completion(.failure(ServiceError.failure))
            }
            
            let decoder = JSONDecoder()
            if let data = data,
               let _ = try? decoder.decode(Bool.self, from: data) {
                completion(.success(true))
            } else {
                completion(.failure(ServiceError.decoding))
            }
            
        })
        task.resume()
    }
}

enum ServiceError: Error {
    case failure
    case decoding
}
