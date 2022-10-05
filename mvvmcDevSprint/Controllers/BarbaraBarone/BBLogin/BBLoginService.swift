import Foundation

enum ErrorType: Error {
    case generic
    case login
    case connectionError
}

protocol BBLogigServicing {
    func fetchLogin(with email: String, completion: @escaping (Result<Session, Error>) -> Void)
}

final class BBLoginService: BBLogigServicing {
    func fetchLogin(with email: String, completion: @escaping (Result<Session, Error>) -> Void) {
        let endpoint = Endpoints.Auth.login
        let parameters = ["email" : email]
        AF.request(endpoint, method: .get, parameters: parameters) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let session = try? decoder.decode(Session.self, from: data) {
                    UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    completion(.success(session))
                } else {
                    completion(.failure(ErrorType.generic))
                }
            case .failure:
                completion(.failure(ErrorType.login))
            }
        }
    }
}
