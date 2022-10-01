//
//  FAAssembly.swift
//  mvvmcDevSprint
//
//  Created by FELIPE AUGUSTO SILVA on 30/09/22.
//

import Foundation
import Swinject

class FALoginFlow {
    public static var shared: Container {
        let container = Container()

        container.register(FALoginViewModel.self) { _ in FALoginViewModelDefault() }
        container.register(FACreateAccountViewModel.self) { _ in FACreateAccountViewModelDefault() }
        container.register(FAResetPasswordViewModel.self) { _ in FAResetPasswordViewModelDefault() }

        return container
    }
}
