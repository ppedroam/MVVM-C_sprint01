import UIKit

enum TRLoginViewControllerFactory {
    static func make() -> UIViewController {
        let coordinator = TRLoginCoordinator()
        let service = TRService()
        let viewModel = TRLoginViewModel(coordinator: coordinator, service: service)
        let controller = TRLoginViewController(viewModel: viewModel)
        viewModel.vc = controller
        coordinator.controller = controller
        return controller
    }
}

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
    
    var viewModel: TRLoginViewModeling
    
    init(viewModel: TRLoginViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.verifyLogin()
        self.ifDebugPasswordMock()
        self.setupView()
        self.validateButton()
        self.configNotificationCenter()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        didClickLogin()
    }
    
    @IBAction func showPassword(_ sender: Any) {
        let imageName = self.showPassword ? "eye.slash" : "eye"
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
        self.resetErrorLogin(emailTextField, textFieldPassword: passwordTextField)
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        validateButton()
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextField.setDefaultColor()
    }
    
    //senha
    @IBAction func passwordBeginEditing(_ sender: Any) {
        self.resetErrorLogin(emailTextField, textFieldPassword: passwordTextField)
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
    
//    func verifyLogin() {
//        self.viewModel.verifyLogin()
//    }
//    
    func didClickLogin() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        self.viewModel.noConnectedInternet()
        
        showLoading()
        self.viewModel.startLogin(email: email, password: password)
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
        heightLabelError.constant = 20
        errorLabel.text = message
        emailTextField.setErrorColor()
        passwordTextField.setErrorColor()
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


private extension TRLoginViewController {
    //MARK: keyboard appearence manager
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
    
    func gestureBtnDidClickView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didClickView))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
    }
    
    func setupLoginBtn() {
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.backgroundColor = .blue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isEnabled = true
    }
    
    func setupCreateAccount() {
        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.blue.cgColor
        createAccountButton.setTitleColor(.blue, for: .normal)
        createAccountButton.backgroundColor = .white
    }
    
    func resetErrorLogin(_ textFieldEmail: UITextField, textFieldPassword: UITextField) {
        heightLabelError.constant = 0
        if viewModel.errorInLogin {
            textFieldEmail.setEditingColor()
            textFieldPassword.setDefaultColor()
        } else {
            textFieldEmail.setDefaultColor()
            textFieldPassword.setDefaultColor()
        }
    }
    
    func validateButton() {
        self.changeButtonStatus(color: .gray, isEnabled: false)
        let email = emailTextField.text
        
        self.viewModel.isEmailValid(email: email ?? "") ? changeButtonStatus(color: .blue, isEnabled: true) : changeButtonStatus(color: .gray, isEnabled: false)
    }
    
    func changeButtonStatus(color: UIColor, isEnabled: Bool) {
        loginButton.backgroundColor = color
        loginButton.isEnabled = isEnabled
    }
}
