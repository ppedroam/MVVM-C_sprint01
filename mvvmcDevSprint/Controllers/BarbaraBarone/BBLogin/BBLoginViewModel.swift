import Foundation

protocol BBLoginViewModeling {
    func makeLogin(with email: String)
    func validateButton(with email: String)
    func verifyLogin()
    func goToHome()
    func goToResetPassword()
    func goToCreateAccount()
}

final class BBLoginViewModel: BBLoginViewModeling {
    var viewController: BBLoginViewControlling?
    private let coordinator: BBLoginCoordinating
    private let service: BBLogigServicing
    
    init(coordinator: BBLoginCoordinator,
         service: BBLogigServicing) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func makeLogin(with email: String) {
        viewController?.showLoading()
        service.fetchLogin(with: email) { result in
            self.viewController?.stopLoading()
            switch result {
            case .success:
                self.verifyLogin()
            case .failure(let error) where error as? ErrorType == ErrorType.generic:
                self.genericError()
            case .failure(let error) where error as? ErrorType == ErrorType.connectionError:
                self.noInternetConnection()
            case .failure:
                self.loginError()
            }
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
    
    func goToHome() {
        coordinator.perform(action: .home)
    }
    
    func goToResetPassword() {
        coordinator.perform(action: .resetPassword)
    }
    
    func goToCreateAccount() {
        coordinator.perform(action: .createAccount)
    }
}

private extension BBLoginViewModel {
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
}
