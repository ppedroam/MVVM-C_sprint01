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
    }
    
    func getRootViewController() -> UIViewController {
        let architecter = Architecters.tatianaRico
        return TRLoginViewController()
    }
//        switch cleanCoder {
//        case .brunaTokie:
//            return createController(storyboardName: "BTUser",
//                                    controllerName: "BTLoginViewController",
//                                    typeOfController: BTLoginViewController.self)
//        case .brunoAlves:
//            return createController(storyboardName: "BAUser",
//                                    controllerName: "BALoginViewController",
//                                    typeOfController: BALoginViewController.self)
//        case .carol:
//            return createController(storyboardName: "CAUser",
//                                    controllerName: "CALoginViewController",
//                                    typeOfController: CALoginViewController.self)
//        case .gabrielaSillis:
//            return createController(storyboardName: "GSUser",
//                                    controllerName: "GSLoginViewController",
//                                    typeOfController: GSLoginViewController.self)
//        case .gabrielCastro:
//            return createController(storyboardName: "GCUser",
//                                    controllerName: "GCLoginViewController",
//                                    typeOfController: GCLoginViewController.self)
//        case .isabellaBencardino:
//            return createController(storyboardName: "IBUser",
//                                    controllerName: "IBLoginViewController",
//                                    typeOfController: IBLoginViewController.self)
//        case .leonardoAlmeida:
//            return createController(storyboardName: "LAUser",
//                                    controllerName: "LALoginViewController",
//                                    typeOfController: LALoginViewController.self)
//        case .marcosJr:
//            return createController(storyboardName: "MJUser",
//                                    controllerName: "MJLoginViewController",
//                                    typeOfController: MJLoginViewController.self)
//        case .pedroTres:
//            return createController(storyboardName: "PTUser",
//                                    controllerName: "PTLoginViewController",
//                                    typeOfController: PTLoginViewController.self)
//        case .rodrigoLemos:
//            return createController(storyboardName: "RLUser",
//                                    controllerName: "RLLoginViewController",
//                                    typeOfController: RLLoginViewController.self)
//        case .tatianaRico:
//            return createController(storyboardName: "TRUser",
//                                    controllerName: "TRLoginViewController",
//                                    typeOfController: TRLoginViewController.self)
//        case .thyagoRaphael:
//            return createController(storyboardName: "THUser",
//                                    controllerName: "THLoginViewController",
//                                    typeOfController: THLoginViewController.self)
//        }
//    }
}

