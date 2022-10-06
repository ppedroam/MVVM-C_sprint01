import UIKit

enum ESLoginFactory {
    static func make() -> UIViewController {
        let coordinator = ESLoginCoordinator()
        let viewModel = ESLoginViewModel(withCoordinator: coordinator)
        let controller = ESLoginViewController(withViewModel: viewModel)
        viewModel.delegate = controller
        coordinator.controller = controller
        return controller
    }
}

class ESLoginViewController: UIViewController {
    
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
    
    private var viewModel: ESLoginViewModelProtocol
    
    init(withViewModel viewModel: ESLoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        initialConstant = topConstraint.constant
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    @IBAction func loginButton(_ sender: Any) {
        let parameters: [String: String] = ["email": emailTextField.text!,
                                            "password": passwordTextField.text!]
                                            
        viewModel.showHomeScreen(parameters: parameters)
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
        viewModel.startResetPasswd()
    }
    
    
    @IBAction func createAccountButton(_ sender: Any) {
        viewModel.createAccount()
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
        if viewModel.errorInLogin {
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
        if viewModel.errorInLogin {
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

extension ESLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let parameters: [String: String] = ["email": emailTextField.text!,
                                            "password": passwordTextField.text!]
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
            viewModel.showHomeScreen(parameters: parameters)
        }
        return true
    }
}

extension ESLoginViewController {
    
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

//MARK: keyboard appearence manager

extension ESLoginViewController {
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
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
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
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

extension ESLoginViewController: ESLoginDelegate {
    func setErrorLogin(_ message: String) {
        viewModel.errorInLogin = true
        heightLabelError.constant = 20
        errorLabel.text = message
        emailTextField.setErrorColor()
        passwordTextField.setErrorColor()
    }
    
    func showLoadingScreen() {
        showLoading()
    }
    
    func stopLoadingScreen() {
        stopLoading()
    }
}
