//
//  mvvmcDevSprintTests.swift
//  mvvmcDevSprintTests
//
//  Created by Pedro Menezes on 22/09/22.
//

import XCTest
@testable import mvvmcDevSprint

class mvvmcDevSprintTests: XCTestCase {
    
    let coordinatorSpy = ResetPasswordCoordinatorSpy()
    let serviceSpy = ResetPasswordServiceSpy()
    let controller = ResetPasswordControllerSpy()
    
    lazy var sut: ResetPasswordViewModel = {
        let viewModel = ResetPasswordViewModel(coordinator: coordinatorSpy, service: serviceSpy)
        viewModel.controller = controller
        return viewModel
    }()
    
    func testGoToAccount_ShouldCallGoToAccountInCoordinator() {
        //given
        
        //when
        sut.goToAccount()
        
        //then
        XCTAssertEqual(coordinatorSpy.performCounter, 1)
        XCTAssertEqual(controller.showSuccessStateCounter, 1)
    }
}

class ResetPasswordCoordinatorSpy: ResetPasswordCoordinating {
    var controller: UIViewController?
    
    private(set) var performCounter = 0
    
    func perform(action: ResetPasswordActions) {
        performCounter += 1
    }
}

class ResetPasswordServiceSpy: ResetPasswordServicing {
    private(set) var tryResetCounter = 0
    
    func tryResetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        tryResetCounter += 1
    }
}

class ResetPasswordControllerSpy: ResetPasswordViewControlling {
    private(set) var showSuccessStateCounter = 0
    
    func showErrorState() {
        return
    }
    
    func showNoInternetAlert() {
        return
    }
    
    func showSuccessState() {
        showSuccessStateCounter += 1
    }
    
    func showDefaultAlert2() {
        return
    }
    
    
}
