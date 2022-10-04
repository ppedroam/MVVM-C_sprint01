import UIKit

enum RRLoginFactory{
    static func make() -> UIViewController {
        let coordinator = RRLoginCoordinator()
        let service = RRLoginRepository()
        let viewModel = RRLoginViewModel(service: service, coordinator: coordinator)
        let controller = RRLoginViewController(viewModel: viewModel)
        viewModel.delegate = controller
        return controller
    }
}

class RRLoginViewController: UIViewController {
    
    @IBOutlet weak var heightLabelError: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    var showPassword = true
    var errorInLogin = false
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    var initialConstant: CGFloat = 0
    let defaultSpacing: CGFloat = 100
    var yVariation: CGFloat = 0
    var textFieldIsMoving = false
    
     
    private let viewModel: RRLoginViewModelToViewProtocol
    
    init(viewModel: RRLoginViewModelToViewProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.verifyLogin()
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
    
    @IBAction func loginButton(_ sender: Any) {
        didClickLogin()
    }
    
    func didClickLogin() {
        viewModel.login(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func showPassword(_ sender: Any) {
        if(showPassword == true) {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage.init(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage.init(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        showPassword = !showPassword
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        let vc = RRResetPasswordViewController()
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

extension RRLoginViewController: RRLoginViewToViewModelProtocol {
    func stateButton(isEnabled: Bool) {
        loginButton.backgroundColor = isEnabled ? .blue : .gray
        loginButton.isEnabled = isEnabled
    }
    
    func showAlertDialog() {
        showAlertDialogDS(title: "Sem conexão", message: "Conecte-se à internet para tentar novamente", buttonTitle: "Ok")
    }
    
    func showLoadingFunc() {
        showLoading()
    }
    
    func stopLoadingFunc() {
        stopLoading()
    }
    
    func setLoginError(_ message: String) {
        errorInLogin = true
        heightLabelError.constant = 20
        errorLabel.text = message
        emailTextField.setErrorColor()
        passwordTextField.setErrorColor()
    }
}

private extension RRLoginViewController {
    
    func showAlertDialogDS(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actin = UIAlertAction(title: buttonTitle, style: .default)
        alertController.addAction(actin)
        present(alertController, animated: true)
    }
}

//MARK: keyboard appearence manager

extension RRLoginViewController {
    func validateButton() {
        viewModel.validateButton(emailText: emailTextField.text!)
    }
    
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
