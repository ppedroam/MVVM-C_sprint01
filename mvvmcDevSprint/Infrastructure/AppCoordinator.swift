import UIKit

struct AppCoordinator {
    static let shared = AppCoordinator()
    
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
    
    func getRootViewController() -> UIViewController {
        var architecter = Architecters.felipeAugusto
        switch architecter {
        case .raulRodrigo: return RRLoginViewController()
        case .henriqueAugusto: return HALoginViewController()
        case .elpidioGabriel: return EGLoginViewController()
        case .gabrielPaschoal: return GPLoginViewController()
        case .danielSeitenfus: return DSLoginViewController()
        case .euclidesSena: return ESLoginViewController()
        case .barbaraBarone: return BBLoginViewController()
        case .tatianaRico: return TRLoginViewController()
        case .felipeAugusto: return FALoginViewController()
        case .luizamoruz: return LMLoginViewController()
        }
    }
}

