import Foundation
import UIKit

enum BBLoginFactory {
    static func make() -> UIViewController {
        let coordinator = BBLoginCoordinator()
        let viewModel = BBLoginViewModel(coordinator: coordinator)
        let controller = BBLoginViewController(viewModel: viewModel)
        viewModel.viewController = controller
        coordinator.controller = controller
        return controller
    }
}
