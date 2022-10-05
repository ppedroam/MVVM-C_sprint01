import UIKit

class GPResetPasswordViewController: UIViewController {
    
    var email = ""
    var loadingScreen = LoadingController()
    var customView = GPResetPasswordView()
    var viewModel: GPResetPasswordViewModelProtocol
    var recoveryEmail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = customView
        bind()
    }
    
    init(
        viewModel: GPResetPasswordViewModelProtocol = GPResetPasswordViewModel()
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        
        
        //        if !email.isEmpty {
        //            emailTextfield.text = email
        //            emailTextfield.isEnabled = false
        //        }
        //        validateButton()
    }
    
    func bind() {
        customView.render()
        clickEvents()
    }
    
    private func clickEvents() {
        customView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonAction)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
        customView.recoverPasswordButton.buttonComponent.addTarget(self, action: #selector(recoverPassword), for: .touchUpInside)
        customView.recoverPasswordButton.buttonComponent.isEnabled = true
        customView.loginButton.buttonComponent.addTarget(self, action: #selector(clickLoginButton), for: .touchUpInside)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc func closeButtonAction() {
        dismiss(animated: true)
    }
    
    @objc func recoverPassword() {
        emailRecovered()
        guard let emailUser = customView.boxResetEmail.emailTextField.text else { return }
        resetPassword(emailUser: emailUser) { success in
            if success {
                self.resetPasswordSuccess()
            } else {
                self.resetPasswordFailure()
            }
        }
    }
    
    func validateForm() -> Bool {
        guard let email = customView.boxResetEmail.emailTextField.text else { return false }
        if viewModel.validateForm(email: email) {
            errorValidate()
        }
        
        return true
    }

    private func errorValidate() -> Bool {
        customView.boxResetEmail.emailTextField.setErrorColor()
        customView.boxResetEmail.emailLabel.textColor = .red
        customView.boxResetEmail.emailLabel.text = "Verifique o e-mail informado"
        return false
    }
    
    private func resetPasswordSuccess() {
        recoveryEmail = true
        customView.boxResetEmail.emailTextField.isHidden = true
        customView.boxResetEmail.emailLabel.isHidden = true
//        self.viewSuccess.isHidden = false
        customView.boxResetEmail.emailLabel.text = customView.boxResetEmail.emailTextField.text?.trimmingCharacters(in: .whitespaces)
        customView.recoverPasswordButton.buttonComponent.setTitle("REENVIAR E-MAIL", for: .normal)
        customView.recoverPasswordButton.buttonComponent.setTitle("Voltar", for: .normal)
    }
    
    private func resetPasswordFailure() {
        let alertController = UIAlertController(title: "Ops..", message: "Algo de errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func resetPassword(emailUser: String, completionHandler: @escaping (Bool) -> Void) {
        viewModel.resetPassword(vc: self, emailUser: emailUser, completionHandler: completionHandler)
    }
    
    private func emailRecovered() {
        if recoveryEmail {
            dismiss(animated: true)
            return
        }
    }
    
    @objc private func clickLoginButton() {
        dismiss(animated: true)
    }

    
    //    @IBAction func helpButton(_ sender: Any) {
    //        let vc = ContactUsViewController()
    //        vc.modalPresentationStyle = .popover
    //        vc.modalTransitionStyle = .coverVertical
    //        self.present(vc, animated: true, completion: nil)
    //    }
    
    //    @IBAction func createAccountButton(_ sender: Any) {
    //        let newVc = CreateAccountViewController()
    //        newVc.modalPresentationStyle = .fullScreen
    //        present(newVc, animated: true)
    //    }
    
    //    //email
    //    @IBAction func emailBeginEditing(_ sender: Any) {
    //        emailTextfield.setEditingColor()
    //    }
    
    //    @IBAction func emailEditing(_ sender: Any) {
    //        emailTextfield.setEditingColor()
    //        validateButton()
    //    }
    
    //    @IBAction func emailEndEditing(_ sender: Any) {
    //        emailTextfield.setDefaultColor()
    //    }
}

//extension GPResetPasswordViewController {
//
//    func validateButton() {
//        if !emailTextfield.text!.isEmpty {
//            enableCreateButton()
//        } else {
//            disableCreateButton()
//        }
//    }
//
//    func disableCreateButton() {
//        recoverPasswordButton.backgroundColor = .gray
//        recoverPasswordButton.setTitleColor(.white, for: .normal)
//        recoverPasswordButton.isEnabled = false
//    }
//
//    func enableCreateButton() {
//        recoverPasswordButton.backgroundColor = .blue
//        recoverPasswordButton.setTitleColor(.white, for: .normal)
//        recoverPasswordButton.isEnabled = true
//    }
//}
