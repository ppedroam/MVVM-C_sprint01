//
//  GPLoginViewModel.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 26/09/22.
//

import UIKit

class GPLoginViewController: UIViewController {
    
    let vc: GPLoginView = GPLoginView()
    let viewModel: GPLoginViewModelProtocol
    
    init(viewModel: GPLoginViewModelProtocol = GPLoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = vc
        vc.setupView()
        verifyLogin()
        vc.emailComponent.emailTextField.text = "mvvmc@devpass.com"
        vc.passwordComponent.passwordTextField.text = "Abcde1"
        validateButton()
        bind()
    }
    
    func bind() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didClickView))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        textFieldActions()
        buttonEvents()
    }
    
    func verifyLogin() {
        if let _ = UserDefaultsManager.UserInfos.shared.readSesion() {
            let vc = UINavigationController(rootViewController: HomeViewController())
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
    }
    
    @objc func didClickLogin() {
        if !viewModel.managerIsConected() {
            loginWithOutConnection()
        }
        
        showLoading()
        guard let email = vc.emailComponent.emailTextField.text else { return }
        guard let password = vc.passwordComponent.passwordTextField.text else { return }
        loginAuthentication(email: email, password: password)
    }
    
    @objc func resetPasswordButton() {
        let vc = GPResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func createAccountButton() {
        let controller = CreateAccountViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    @objc func didClickView() {
        view.endEditing(true)
    }
    
    @objc private func validateButton() {
        guard let email = vc.emailComponent.emailTextField.text else { return }
        let validate = viewModel.validateEmail(email: email)
        if !validate {
            disableButton()
        } else {
            if viewModel.secondValidateEmail(email: email) {
                enableButton()
            } else {
                disableButton()
            }
        }
    }
    
    private func loginAuthentication(email: String, password: String) {
        self.stopLoading()
    
        if !viewModel.loginAuthentication(email: email, password: password) {
            self.showServiceError()
            return
        }
        
        self.loginFailure()
        self.loginSucess()
        
    }
    
    private func loginSucess() {
        self.textFieldErrorState(hasError: false)
        self.vc.showMessageError(state: true)
    }
    
    private func loginFailure() {
        if self.viewModel.hasError {
            Globals.alertMessage(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.", targetVC: self)
        }
    }
    
    private func showServiceError() {
        self.textFieldErrorState(hasError: true)
        self.vc.showMessageError(state: false)
        Globals.alertMessage(title: "Ops..", message: "Houve um problema, tente novamente mais tarde.", targetVC: self)
    }
    
    private func buttonEvents() {
        vc.emailComponent.emailTextField.delegate = self
        vc.passwordComponent.passwordTextField.delegate = self
        vc.loginButton.addTarget(self, action: #selector(didClickLogin), for: .touchUpInside)
        vc.passwordComponent.forgotPasswordButton.addTarget(self, action: #selector(resetPasswordButton), for: .touchUpInside)
        vc.createAccountButton.addTarget(self, action: #selector(createAccountButton), for: .touchUpInside)
    }
    
    private func textFieldActions() {
        vc.emailComponent.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        vc.emailComponent.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        vc.emailComponent.emailTextField.addTarget(self, action: #selector(validateButton), for: .editingDidEnd)
        vc.passwordComponent.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        vc.passwordComponent.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        vc.passwordComponent.passwordTextField.addTarget(self, action: #selector(validateButton), for: .editingDidEnd)
    }
    
    private func textFieldErrorState(hasError: Bool) {
        self.vc.passwordComponent.passwordTextField.resetError(hasError: hasError)
        self.vc.emailComponent.emailTextField.resetError(hasError: hasError)
    }
    
    private func loginWithOutConnection() {
        let alertController = UIAlertController(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente", preferredStyle: .alert)
        let actin = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(actin)
        present(alertController, animated: true)
        return
    }
    
    private func disableButton() {
        vc.loginButton.backgroundColor = .gray
        vc.loginButton.isEnabled = false
    }
    
    private func enableButton() {
        vc.loginButton.backgroundColor = .blue
        vc.loginButton.isEnabled = true
    }
    
  }

extension GPLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == vc.emailComponent.emailTextField {
            vc.passwordComponent.passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
            didClickLogin()
        }
        return true
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textField.setEditingColor()
    }
}
