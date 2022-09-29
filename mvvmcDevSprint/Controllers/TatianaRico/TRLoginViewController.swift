import UIKit

class TRLoginViewController: UIViewController {
    @IBOutlet weak var heightLabelError: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var initialConstant: CGFloat = 0
    let defaultSpacing: CGFloat = 100
    var yVariation: CGFloat = 0
    var textFieldIsMoving = false
    var showPassword = true
    var errorInLogin = false
    var viewModel = TRLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyLogin()
        
        self.ifDebugPasswordMock()
        self.setupView()
        self.validateButton()
        self.configNotificationCenter()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        didClickLogin()
    }
    
    @IBAction func showPassword(_ sender: Any) {
        let imageName = showPassword ? "eye.slash" : "eye"
        let image = UIImage.init(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        showPasswordButton.setImage(image, for: .normal)
        passwordTextField.isSecureTextEntry = showPassword
        showPassword = !showPassword
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        self.viewModel.goToResetPassword()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        self.viewModel.goToCreatAccount()
    }
    
    //email
    @IBAction func emailBeginEditing(_ sender: Any) {
        if errorInLogin {
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
        if errorInLogin {
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
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func ifDebugPasswordMock() {
#if DEBUG
        emailTextField.text = "mvvmc@devpass.com"
        passwordTextField.text = "Abcde1"
#endif
    }
    
    func configNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func verifyLogin() {
        self.viewModel.verifyLogin()
    }
    
    func didClickLogin() {
        let email = emailTextField.text ?? ""
        let password = emailTextField.text ?? ""
        
        if !ConnectivityManager.shared.isConnected {
            self.viewModel.alertConexao(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente")
        }
        
        showLoading()
        self.viewModel.requestScreenLogin(email: email, password: password)
    }
    
    func globalsAlerts(title: String, message: String) {
        Globals.alertMessage(title: title, message: message, targetVC: self)
    }
    
    func setupView() {
        initialConstant = topConstraint.constant
        showPasswordButton.tintColor = .lightGray
        heightLabelError.constant = 0
        
        setupLoginBtn()
        setupCreateAccount()
        setupTextField()
        gestureBtnDidClickView()
        validateButton()
    }
    
    private func gestureBtnDidClickView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didClickView))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
    }
    
    private func setupLoginBtn() {
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.backgroundColor = .blue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isEnabled = true
    }
    
    private func setupCreateAccount() {
        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.blue.cgColor
        createAccountButton.setTitleColor(.blue, for: .normal)
        createAccountButton.backgroundColor = .white
    }
    
    private func setupTextField() {
        emailTextField.setDefaultColor()
        passwordTextField.setDefaultColor()
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc func didClickView() {
        view.endEditing(true)
    }
    
    func goToHome() {
        let vc = UINavigationController(rootViewController: HomeViewController())
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func setErrorLogin(_ message: String) {
        errorInLogin = true
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
    
    func validateButton() {
        self.changeButtonStatus(color: .gray, isEnabled: false)
        let email = emailTextField.text
        
        self.viewModel.isEmailValid(email: email ?? "") ? changeButtonStatus(color: .blue, isEnabled: true) : changeButtonStatus(color: .gray, isEnabled: false)
    }
    
    private func changeButtonStatus(color: UIColor, isEnabled: Bool) {
        loginButton.backgroundColor = color
        loginButton.isEnabled = isEnabled
    }
}

extension TRLoginViewController: UITextFieldDelegate {
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

//MARK: keyboard appearence manager

extension TRLoginViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              isNeededToMoveTextfield(keyboardOriginY: keyboardSize.minY) else {
            return
        }
        
        guard !textFieldIsMoving else { return }
        textFieldIsMoving = true
        
        let currentConstraintValue = topConstraint.constant
        
        UIView.animate(withDuration: 0.1, animations: {
            self.topConstraint.constant = currentConstraintValue - self.yVariation
            self.view.layoutIfNeeded()
        }) { _ in
            self.textFieldIsMoving = false
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if topConstraint.constant != initialConstant {
            guard !textFieldIsMoving else { return }
            textFieldIsMoving = true
            
            UIView.animate(withDuration: 0.1, animations: {
                self.topConstraint.constant = self.initialConstant
                self.view.layoutIfNeeded()
            }) { _ in
                self.textFieldIsMoving = false
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
        let newOriginY = keyboardOriginY - textFieldHeight - defaultSpacing
        yVariation = activeTFWindowPosition.minY - newOriginY
        let isTextFieldTooNearFromKeyboard = activeTFWindowPosition.minY > newOriginY
        return isTextFieldTooNearFromKeyboard
    }
}
