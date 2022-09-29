import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var email = ""
    var loadingScreen = LoadingController()
    var recoveryEmail = false
    let viewModel = ResetPasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gesture)
        viewModel.controller = self
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func recoverPasswordButton(_ sender: Any) {
        if recoveryEmail {
            dismiss(animated: true)
            return
        }

        if validateForm() {
            callAPI()
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func helpButton(_ sender: Any) {
        let vc = ContactUsViewController()
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let newVc = CreateAccountViewController()
        newVc.modalPresentationStyle = .fullScreen
        present(newVc, animated: true)
    }
    
    func validateForm() -> Bool {
        let emailString = emailTextfield.text ?? ""
        let isValid = viewModel.validateEmail(email: emailString)
        if !isValid {
            emailTextfield.setErrorColor()
            textLabel.textColor = .red
            textLabel.text = "Verifique o e-mail informado"
        }
        return isValid
    }
    
    func setupView() {
        recoverPasswordButton.layer.cornerRadius = recoverPasswordButton.bounds.height / 2
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)

        loginButton.layer.cornerRadius = createAccountButton.frame.height / 2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.blue.cgColor
        loginButton.setTitleColor(.blue, for: .normal)
        loginButton.backgroundColor = .white
        
        helpButton.layer.cornerRadius = createAccountButton.frame.height / 2
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.blue.cgColor
        helpButton.setTitleColor(.blue, for: .normal)
        helpButton.backgroundColor = .white
        
        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.blue.cgColor
        createAccountButton.setTitleColor(.blue, for: .normal)
        createAccountButton.backgroundColor = .white
        
        emailTextfield.setDefaultColor()
        
        if !email.isEmpty {
            emailTextfield.text = email
            emailTextfield.isEnabled = false
        }
        validateButton()
    }
    
    //email
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
        validateButton()
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }
}

extension ResetPasswordViewController {
    
    func showNoInternetAlert() {
        Globals.showNoInternetCOnnection(controller: self)
    }
    
    func showSuccessState() {
        recoveryEmail = true
        emailTextfield.isHidden = true
        textLabel.isHidden = true
        viewSuccess.isHidden = false
        emailLabel.text = self.emailTextfield.text?.trimmingCharacters(in: .whitespaces)
        recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
        recoverPasswordButton.setTitle("Voltar", for: .normal)
    }
    
    func validateButton() {
        if !emailTextfield.text!.isEmpty {
            enableCreateButton()
        } else {
            disableCreateButton()
        }
    }
    
    func disableCreateButton() {
        recoverPasswordButton.backgroundColor = .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = false
    }
    
    func enableCreateButton() {
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = true
    }
}

private extension ResetPasswordViewController {
    func callAPI() {
        self.view.endEditing(true)
        let email = emailTextfield.text ?? ""
        viewModel.callAPI(email: email)
    }
}

extension UIViewController {
    func showDefaultAlert() {
        let alertController = UIAlertController(title: "Ops..", message: "Algo de errado aconteceu. Tente novamente mais tarde.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
