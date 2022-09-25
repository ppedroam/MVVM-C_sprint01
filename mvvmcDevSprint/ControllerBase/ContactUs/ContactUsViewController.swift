//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit
import MessageUI

class ContactUsViewController: BaseViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    func closeKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func didClickWhatsapp(_ sender: UIButton) {
        let application = UIApplication.shared
        let phoneNumber =  "invalido"
        let urlString =  "https://wa.me/\(phoneNumber)"
        if let appURL = URL(string: urlString),
           application.canOpenURL(appURL) {
            application.open(appURL, options: [:], completionHandler: nil)
        } else {
            Globals.alertMessage(title: "Erro", message: "Nenhum aplicativo de telefone encontrado", targetVC: self)
        }
    }
    
    @IBAction func callPhoneButton(_ sender: Any) {
        if let url = URL(string: "tel://08007092227"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            Globals.alertMessage(title: "Erro", message: "Nenhum aplicativo de telefone encontrado", targetVC: self)
        }
    }

    @IBAction func didClickYoutube(_ sender: Any) {
        let youtubeId = "UCMA72bNWUzFlTODN63ovYTw"
        var url = URL(string:"youtube://\(youtubeId)")!
        if !UIApplication.shared.canOpenURL(url)  {
            url = URL(string:"https://www.youtube.com/channel/UCMA72bNWUzFlTODN63ovYTw")!
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func didClickLinkedin(_ sender: Any) {
        let username =  "pedro-araujo-menezes/"
        let appURL = URL(string: "linkedin://profile/\(username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "http://www.linkedin.com/profile/\(username)")!
            application.open(webURL)
        }
    }
    
    @IBAction func didLickMedium(_ sender: Any) {
        let application = UIApplication.shared
        let webURL = URL(string: "https://ppedroam.medium.com")!
        application.open(webURL)
    }
    
    @IBAction func didClickSendButton(_ sender: UIButton) {
        let message = messageTextView.text ?? ""
        guard message.count > 0 else { return }
        
        let parameters: [String: String] = [
            "email": "lagosta@devpass.com.br",
            "mensagem": message
        ]
        let url = Endpoints.sendMessage
        showLoading()
        AF.request(url, method: .post, parameters: parameters, headers: nil) { result in
            self.stopLoading()
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.sendMessageButton.isHidden = true
                    self.messageTextView.text = "Texto enviado"
                    self.messageTextView.isUserInteractionEnabled = false
                    self.showToast(message: "Mensagem enviada")
                }
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
            }
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
}

extension ContactUsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholder {
            textView.text = ""
        }
    }
}

