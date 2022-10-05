import Foundation
import UIKit

enum BBLoginFactory {
    static func make() -> UIViewController {
        let coordinator = BBLoginCoordinator()
        let service = BBLoginService()
        let viewModel = BBLoginViewModel(coordinator: coordinator, service: service)
        let controller = BBLoginViewController(viewModel: viewModel)
        viewModel.viewController = controller
        coordinator.controller = controller
        return controller
    }
}
