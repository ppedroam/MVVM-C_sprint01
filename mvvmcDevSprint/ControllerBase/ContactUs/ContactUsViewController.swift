//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit
import MessageUI

enum ContactUsFactory {
    static func make() -> UIViewController {
        let viewModel = ContactUsViewModel()
        let controller = ContactUsViewController(viewModel: viewModel)
        viewModel.controller = controller
        return controller
    }
}

protocol ContactUsViewControlling {
    func showLoading()
    func showErrorAlert(message: String)
    func stopLoading()
    func didSendMessage()
}

class ContactUsViewController: UIViewController, Toastable {
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var viewBlackSendMessage: UIView!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var viewLinkedin: UIView!
    @IBOutlet weak var viewInstagram: UIView!
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var whatsapImage: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var youtubeImageView: UIImageView!
    @IBOutlet weak var linkedinImageView: UIImageView!
    @IBOutlet weak var mediumImageView: UIImageView!
    
    let textViewPlaceholder = "Escreva seu texto aqui"
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let viewModel: ContactUsViewModeling
    
    init(viewModel: ContactUsViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.getInfos()
    }
    
    @IBAction func didClickClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func setupView() {
        viewContent.layer.cornerRadius = 5
        viewSendMessage.layer.cornerRadius = 3
        viewBlackSendMessage.layer.cornerRadius = 5
        viewCall.layer.cornerRadius = 3
        viewFacebook.layer.cornerRadius = 3
        viewLinkedin.layer.cornerRadius = 3
        viewInstagram.layer.cornerRadius = 3
        
        adressLabel.text = "Deseja enviar uma mensagem?"
        
        configImages()
        addGesture()
    }
    
    @objc
    func closeKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func didClickWhatsapp(_ sender: UIButton) {
        viewModel.didClickExternalTool(type: .whatsapp)
    }
    
    @IBAction func callPhoneButton(_ sender: Any) {
        viewModel.didClickExternalTool(type: .telephone)
    }
    
    @IBAction func didClickYoutube(_ sender: Any) {
        viewModel.didClickExternalTool(type: .youtube)
    }
    
    @IBAction func didClickLinkedin(_ sender: Any) {
        viewModel.didClickExternalTool(type: .linkedin)
    }
    
    @IBAction func didLickMedium(_ sender: Any) {
        viewModel.didClickExternalTool(type: .medium)
    }
    
    @IBAction func didClickSendButton(_ sender: UIButton) {
        let message = messageTextView.text ?? ""
        guard message.count > 0 else { return }
        viewModel.sendMessage(message)
    }
    
    private func showAlert(title: String, message: String?, completion: @escaping ()->Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alertController.dismiss(animated: true)
            completion()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    private func configImages() {
        let size = 15
        whatsapImage.image = UIImage(named: "whats")?.icon(size: size).withRenderingMode(.alwaysTemplate)
        whatsapImage.tintColor = .white
        whatsapImage.contentMode = .scaleAspectFit
        phoneImageView.image = UIImage(named: "phone")?.icon(size: size).withRenderingMode(.alwaysTemplate)
        phoneImageView.tintColor = .white
        phoneImageView.contentMode = .scaleAspectFit
        youtubeImageView.image = UIImage(named: "youtube")?.icon(size: size).withRenderingMode(.alwaysTemplate)
        youtubeImageView.tintColor = .white
        youtubeImageView.contentMode = .scaleAspectFit
        linkedinImageView.image = UIImage(named: "linkedin")?.icon(size: size).withRenderingMode(.alwaysTemplate)
        linkedinImageView.tintColor = .white
        linkedinImageView.contentMode = .scaleAspectFit
        mediumImageView.image = UIImage(named: "medium")?.icon(size: size).withRenderingMode(.alwaysTemplate)
        mediumImageView.tintColor = .white
        mediumImageView.contentMode = .scaleAspectFit
        sendMessageButton.layer.cornerRadius = sendMessageButton.frame.height/2
        sendMessageButton.setTitleColor(.white, for: .disabled)
        messageTextView.delegate = self
        messageTextView.text = textViewPlaceholder
        messageTextView.autocorrectionType = .no
        messageTextView.spellCheckingType = .no
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gesture)
    }
}

extension ContactUsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholder {
            textView.text = ""
        }
    }
}

extension ContactUsViewController: ContactUsViewControlling {
    func showErrorAlert(message: String) {
        self.showAlert(title: "Opss..", message: message) {
            self.dismiss(animated: true)
        }
    }
    
    func didSendMessage() {
        self.sendMessageButton.isHidden = true
        self.messageTextView.text = "Texto enviado"
        self.messageTextView.isUserInteractionEnabled = false
        self.showToast(message: "Mensagem enviada")
    }
}
