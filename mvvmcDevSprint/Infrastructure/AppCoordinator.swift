import UIKit

struct AppCoordinator {
    private let loggedUserChecker: LoggedUserChecking
    
    init(loggedUserChecker: LoggedUserChecking) {
        self.loggedUserChecker = loggedUserChecker
    }
    
    private let hasToCompleteRegistration = false
    private let didClickContactOutOfAPP = false
    
    func getRootViewController() -> UIViewController {
        let isUserLogged = loggedUserChecker.isUserLogged
        var controller: UIViewController
        if isUserLogged {
            controller = UINavigationController(rootViewController: HomeViewController())
        } else if hasToCompleteRegistration {
            controller = CreateAccountViewController()
        } else if didClickContactOutOfAPP {
            controller = ContactUsFactory.make()
        } else {
            controller = getLoginViewController()
        }
        return controller
    }
    
    private enum Architecters {
        case raulRodrigo
        case henriqueAugusto
        case elpidioGabriel
        case gabrielPaschoal
        case danielSeitenfus
        case euclidesSena
        case barbaraBarone
        case tatianaRico
        case felipeAugusto
        case luizamoruz
    }
    
    private func getLoginViewController() -> UIViewController {
        var architecter = Architecters.elpidioGabriel

        switch architecter {
        case .raulRodrigo: return RRLoginViewController()
        case .henriqueAugusto: return HALoginViewController()
        case .elpidioGabriel: return EGLoginViewController()
        case .gabrielPaschoal: return GPLoginViewController()
        case .danielSeitenfus: return DSLoginViewController()
        case .euclidesSena: return ESLoginFactory.make()
        case .barbaraBarone: return BBLoginViewController()
        case .tatianaRico: return TRLoginViewController()
        case .felipeAugusto: return FALoginViewController()
        case .luizamoruz: return LMLoginViewController()
        }
    }
}


protocol LoggedUserChecking {
    var isUserLogged: Bool { get }
}

struct LoggedUserChecker: LoggedUserChecking {
    var isUserLogged: Bool {
        let user  = UserDefaultsManager.UserInfos.shared.readSesion()
        let isUserLogged = user != nil
        return isUserLogged
    }
}
