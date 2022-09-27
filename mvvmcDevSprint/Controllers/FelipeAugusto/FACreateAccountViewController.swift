import UIKit

class FACreateAccountViewController: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var documentTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmation: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var passwordConfirmation: UITextField!
    @IBOutlet weak var showConfirmPasswordButton: UIButton!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var documentErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailConfirmationErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

// MARK: - Actions
    @IBAction func closedButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
    }

    @IBAction func nameEditing(_ sender: Any) {
    }

    @IBAction func nameBeginEditing(_ sender: Any) {
    }
    
    @IBAction func nameEndEditing(_ sender: Any) {
    }
    
    @IBAction func phoneEditing(_ sender: Any) {
    }
    
    @IBAction func phoneBeginEditing(_ sender: Any) {
    }
    
    @IBAction func phoneEndEditing(_ sender: Any) {
    }
    
    @IBAction func documetEditing(_ sender: Any) {
    }
    
    @IBAction func documentBeginEditing(_ sender: Any) {
    }
    
    @IBAction func documentEndEditing(_ sender: Any) {
    }
    
    @IBAction func emailEditing(_ sender: Any) {
    }
    
    @IBAction func emailBeginEditing(_ sender: Any) {
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
    }
    
    @IBAction func emailConfirmationEditing(_ sender: Any) {
    }
    
    @IBAction func emailConfirmationBeginEditing(_ sender: Any) {
    }
    @IBAction func emailConfirmationEndEditing(_ sender: Any) {
    }
    
    @IBAction func passwordEditing(_ sender: Any) {
    }
    
    @IBAction func passwordBeginEditing(_ sender: Any) {
    }
    
    @IBAction func passwordEndEditing(_ sender: Any) {
    }
    
    @IBAction func passwordConfirmationEditing(_ sender: Any) {
    }
    
    @IBAction func passwordConfirmationBeginEditing(_ sender: Any) {
    }
    
    @IBAction func passwordConfirmationEndEditing(_ sender: Any) {
    }
    
    @IBAction func showPassword(_ sender: Any) {
    }
    
    @IBAction func showConfirmPassword(_ sender: Any) {
    }

    func setupView() {        
        hideKeyboardWhenTappedAround()
        viewMain.layer.cornerRadius = 5
        createButton.layer.cornerRadius = createButton.frame.height / 2

        nameTextField.setDefaultColor()
        phoneTextField.setDefaultColor()
        documentTextField.setDefaultColor()
        emailTextField.setDefaultColor()
        emailConfirmation.setDefaultColor()
        passwordTextField.setDefaultColor()
        passwordConfirmation.setDefaultColor()
        passwordTextField.textContentType = .oneTimeCode
        passwordConfirmation.textContentType = .oneTimeCode
    }
}
