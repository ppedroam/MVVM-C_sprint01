import Foundation

final class BBLoginViewModel {
    let endpoint = Endpoints.Auth.login
    weak var viewController: BBLoginViewController?
    
    func fetchLogin(with email: String) {
        let parameters = ["email" : email]
        noInternetConnection()
        viewController?.showLoading()
        AF.request(endpoint, method: .get, parameters: parameters) { result in
            DispatchQueue.main.async {
                self.viewController?.stopLoading()
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let session = try? decoder.decode(Session.self, from: data) {
                        UserDefaultsManager.UserInfos.shared.save(session: session, user: nil)
                    } else {
                        self.genericError()
                    }
                case .failure:
                    self.loginError()
                }
            }
        }
    }
    
    func loginError() {
        viewController?.showLoginError()
    }
    
    func genericError() {
        viewController?.showGenericErrorAlert()
    }
    
    func noInternetConnection() {
        if !ConnectivityManager.shared.isConnected {
            viewController?.showAlertConnectivity()
        }
    }
    
    func verifyLogin() {
        if let _ = UserDefaultsManager.UserInfos.shared.readSesion() {
            viewController?.showHomeScreen()
        }
    }
    
    func validateButton(with email: String) {
        if email.contains(".") && email.contains("@") && email.count > 5 {
            viewController?.enableButton()
        } else {
            if let atIndex = email.firstIndex(of: "@") {
                let substring = email[atIndex...]
                if substring.contains(".") {
                    viewController?.enableButton()
                } else {
                    viewController?.disableButton()
                }
            } else {
                viewController?.disableButton()
            }
        }
    }
}
