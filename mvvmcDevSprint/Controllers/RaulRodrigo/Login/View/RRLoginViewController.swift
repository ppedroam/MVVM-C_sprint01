import UIKit

protocol RRLoginViewControllerProtocol {
    func showLoadingFunc()
    func stopLoadingFunc()
    func goToHome()
    func setLoginError()
}

class RRLoginViewController: UIViewController {
    
    @IBOutlet weak var heightLabelError: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyLogin()

        #if DEBUG
        emailTextField.text = "mvvmc@devpass.com"
        passwordTextField.text = "Abcde1"
        #endif

        self.setupView()
        self.validateButton()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
        viewModel.initialConstant(initial: topConstraint.constant) 
    }
    
    lazy var viewModel: RRLoginViewModelProtocol = {
       return RRLoginViewModel()
    }()
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func verifyLogin() {
        if viewModel.verifyLogin() {
            goToHome()
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        didClickLogin()
    }
    
    func didClickLogin() {
        showOutConnectionDialog()
        showLoading()
        viewModel.login(email: emailTextField.text!, password: passwordTextField.text!, targetVC: self)
        
    }
    
    @IBAction func showPassword(_ sender: Any) {
        if(viewModel.showPassword == true) {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage.init(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage.init(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        viewModel.showPassword = !viewModel.showPassword
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        let vc = ResetPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    @IBAction func createAccountButton(_ sender: Any) {
        let controller = CreateAccountViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func setupView() {
        heightLabelError.constant = 0
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.backgroundColor = .blue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isEnabled = true

        showPasswordButton.tintColor = .lightGray

        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.blue.cgColor
        createAccountButton.setTitleColor(.blue, for: .normal)
        createAccountButton.backgroundColor = .white
        
        emailTextField.setDefaultColor()
        passwordTextField.setDefaultColor()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didClickView))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        validateButton()
        
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @objc
    func didClickView() {
        view.endEditing(true)
    }
    
    //email
    @IBAction func emailBeginEditing(_ sender: Any) {
        if  viewModel.errorInLogin {
            resetErrorLogin(emailTextField)
        } else {
            emailTextField.setEditingColor()
        }
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        validateButton()
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextField.setDefaultColor()
    }
    
    //senha
    @IBAction func passwordBeginEditing(_ sender: Any) {
        if  viewModel.errorInLogin {
            resetErrorLogin(passwordTextField)
        } else {
            passwordTextField.setEditingColor()
        }
    }
    
    @IBAction func passwordEditing(_ sender: Any) {
        validateButton()
    }
    
    @IBAction func passwordEndEditing(_ sender: Any) {
        passwordTextField.setDefaultColor()
    }
    
    func setErrorLogin(_ message: String) {
        viewModel.errorInLogin = true
        heightLabelError.constant = 20
        errorLabel.text = message
        emailTextField.setErrorColor()
        passwordTextField.setErrorColor()
    }
    
    func resetErrorLogin(_ textField: UITextField) {
        heightLabelError.constant = 0
        if textField == emailTextField {
            emailTextField.setEditingColor()
            passwordTextField.setDefaultColor()
        } else {
            emailTextField.setDefaultColor()
            passwordTextField.setDefaultColor()
        }
    }
}

extension RRLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
            didClickLogin()
        }
        return true
    }
}

private extension RRLoginViewController {
    
    func  showOutConnectionDialog(){
        if !ConnectivityManager.shared.isConnected {
            showAlertDialog(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente", buttonTitle: "Ok")
            return
        }
    }
    
    func validateButton() {
        if !emailTextField.text!.contains(".") ||
            !emailTextField.text!.contains("@") ||
            emailTextField.text!.count <= 5 {
            disableButton()
        } else {
            if let atIndex = emailTextField.text!.firstIndex(of: "@") {
                let substring = emailTextField.text![atIndex...]
                if substring.contains(".") {
                    enableButton()
                } else {
                    disableButton()
                }
            } else {
                disableButton()
            }
        }
    }
    
    func disableButton() {
        loginButton.backgroundColor = .gray
        loginButton.isEnabled = false
    }
    
    func enableButton() {
        loginButton.backgroundColor = .blue
        loginButton.isEnabled = true
    }
    
}

extension RRLoginViewController: RRLoginViewControllerProtocol {
    func setLoginError() {
        self.setErrorLogin("E-mail ou senha incorretos")
    }
    
    func goToHome() {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
     func stopLoadingFunc() {
        stopLoading()
    }
     func showLoadingFunc() {
        showLoading()
    }
}

//MARK: keyboard appearence manager

extension RRLoginViewController {
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              isNeededToMoveTextfield(keyboardOriginY: keyboardSize.minY) else {
                  return
              }

        guard !viewModel.textFieldIsMoving else { return }
        viewModel.textFieldIsMoving = true

        let currentConstraintValue = topConstraint.constant

        UIView.animate(withDuration: 0.1, animations: {
            self.topConstraint.constant = currentConstraintValue - self.viewModel.yVariation
            self.view.layoutIfNeeded()
        }) { _ in
            self.viewModel.textFieldIsMoving = false
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        if topConstraint.constant != viewModel.initialConstant {
            guard viewModel.textFieldIsMoving  else { return }
            viewModel.textFieldIsMoving = true

            UIView.animate(withDuration: 0.1, animations: {
                self.topConstraint.constant = self.viewModel.initialConstant
                self.view.layoutIfNeeded()
            }) { _ in
                self.viewModel.textFieldIsMoving = false
            }
        }
    }
    
    func isNeededToMoveTextfield(keyboardOriginY: CGFloat) -> Bool {
        guard let textFields = self.view?.allSubViewsOf(type: UITextField.self),
              let activeTextField = textFields.first(where: {$0.isFirstResponder}),
              let activeTFWindowPosition = activeTextField.superview?.convert(activeTextField.frame, to: nil) else {
            return false
              }

        let textFieldHeight = activeTextField.frame.height
        let newOriginY = keyboardOriginY - textFieldHeight - viewModel.defaultSpacing 
        viewModel.yVariation = activeTFWindowPosition.minY - newOriginY
        let isTextFieldTooNearFromKeyboard = activeTFWindowPosition.minY > newOriginY
        return isTextFieldTooNearFromKeyboard
    }
}
