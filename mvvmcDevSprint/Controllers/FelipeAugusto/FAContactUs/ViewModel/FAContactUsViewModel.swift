//
//  FAContactUsViewModel.swift
//  mvvmcDevSprint
//
//  Created by FELIPE AUGUSTO SILVA on 27/09/22.
//

import Foundation
enum NetworkError: Error {
    case badURL
}
class FAContactUsViewModel {

    func getInfos(url: String, completionHandler: @escaping (Result<LagostaInfos, NetworkError>) -> Void) {
        AF.request(url, method: .get, parameters: nil, headers: nil) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let infos = try? decoder.decode(LagostaInfos.self, from: data) {
                    completionHandler(.success(infos))
                }
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
                completionHandler(.failure(NetworkError.badURL))
            }
        }
    }
}
