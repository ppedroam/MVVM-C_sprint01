//
//  FAAuthenticationCoordinator.swift
//  mvvmcDevSprint
//
//  Created by FELIPE AUGUSTO SILVA on 30/09/22.
//

import Foundation
import UIKit
import Swinject

class FAAuthenticationCoordinator: Coordinator {

    var navigationController: UINavigationController?

    func start() {
        let newVc = buildController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.setViewControllers([newVc], animated: false)
    }

    func buildController() -> UIViewController {
        guard let viewModel: FALoginViewModel = FALoginFlow.shared.resolve(FALoginViewModel.self) else {
            fatalError()
        }
        let contoller = FALoginViewController(viewModel: viewModel)
        contoller.coordinator = self
        return contoller
    }

}

extension FAAuthenticationCoordinator: Coordinating {

    func openForgotPassword() {
        guard let viewModel: FAResetPasswordViewModel = FALoginFlow.shared.resolve(FAResetPasswordViewModel.self) else {
            fatalError()
        }
        let controller = FAResetPasswordViewController(viewModel: viewModel)
        presentView(controller, mode: .fullScreen)
    }

    func openCreateAccount() {
        guard let viewModel: FACreateAccountViewModel = FALoginFlow.shared.resolve(FACreateAccountViewModel.self) else {
            fatalError()
        }
        let controller = FACreateAccountViewController(viewModel: viewModel)
        presentView(controller, mode: .fullScreen)
    }

    func openContactUs() {
    }

    private func presentView(_ controller: UIViewController, mode: UIModalPresentationStyle) {
        controller.modalPresentationStyle = mode
        navigationController?.present(controller, animated: true)
    }
}
