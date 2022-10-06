//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit
import MessageUI

class GPContactUsViewController: BaseViewController {
    
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
    var lagostaInfos: LagostaInfos?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getInfos()
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
    
    func getInfos() {
        let url = Endpoints.getLagostaInfos
        showLoading()
        AF.request(url, method: .get, parameters: nil, headers: nil) { result in
            self.stopLoading()
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let infos = try? decoder.decode(LagostaInfos.self, from: data) {
                    self.lagostaInfos = infos
                } else {
                    self.showAlert(title: "Opss..", message: "Erro ao receber os dados. Tente novamente mais tarde") {
                        self.dismiss(animated: true)
                    }
                }
            case .failure(let error):
                print("error api: \(error.localizedDescription)")
                self.showDefaultAlert()
            }
        }
    }
    
    @IBAction func didClickWhatsapp(_ sender: UIButton) {
        let application = UIApplication.shared
        let phoneNumber =  lagostaInfos?.whatsapp ?? ""
        let urlString =  "https://wa.me/\(phoneNumber)"
        if let appURL = URL(string: urlString),
           application.canOpenURL(appURL) {
            application.open(appURL, options: [:], completionHandler: nil)
        } else {
            Globals.alertMessage(title: "Erro", message: "Nenhum aplicativo de telefone encontrado", targetVC: self)
        }
    }
    
    @IBAction func callPhoneButton(_ sender: Any) {
        let tel = lagostaInfos?.phone ?? ""
        if let url = URL(string: "tel://\(tel)"),
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
        let youtubeId = lagostaInfos?.youtubeID ?? ""
        var url = URL(string:"youtube://\(youtubeId)")!
        if !UIApplication.shared.canOpenURL(url)  {
            url = URL(string:"https://www.youtube.com/channel/\(youtubeId)")!
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func didClickLinkedin(_ sender: Any) {
        let username =  lagostaInfos?.linkedinID ?? ""
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
        let urlString = lagostaInfos?.mediumURL ?? ""
        let webURL = URL(string: urlString)!
        application.open(webURL)
    }
    
    @IBAction func didClickSendButton(_ sender: UIButton) {
        let message = messageTextView.text ?? ""
        guard message.count > 0 else { return }
        
        let mail = lagostaInfos?.mail ?? ""
        let parameters: [String: String] = [
            "email": mail,
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
}

extension GPContactUsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholder {
            textView.text = ""
        }
    }
}

