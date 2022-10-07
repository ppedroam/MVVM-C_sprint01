//
//  ContactUsViewModel.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 06/10/22.
//

import Foundation

enum ExternalTool {
    case linkedin
    case medium
    case youtube
    case telephone
    case whatsapp
}

protocol ContactUsViewModeling {
    func getInfos()
    func sendMessage(_ message: String)
    func didClickExternalTool(type: ExternalTool)
}

class ContactUsViewModel: ContactUsViewModeling {
    var controller: ContactUsViewControlling?
    private let externalToolHandler: ExternalToolHandling
    private var lagostaInfos: LagostaInfos?
    
    init(externalToolHandler: ExternalToolHandling = ExternalToolHandler()) {
        self.externalToolHandler = externalToolHandler
    }

    func getInfos() {
        let url = Endpoints.getLagostaInfos
        controller?.showLoading()
        AF.request(url, method: .get, parameters: nil, headers: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleGetUserInfoResponse(with: result)
            }
        }
    }
    
    func sendMessage(_ message: String) {
        let mail = lagostaInfos?.mail ?? ""
        let parameters: [String: String] = [
            "email": mail,
            "mensagem": message
        ]
        let url = Endpoints.sendMessage
        controller?.showLoading()
        AF.request(url, method: .post, parameters: parameters, headers: nil) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleSendMessageResponse(result: result)
            }
        }
    }
    
    func didClickExternalTool(type: ExternalTool) {
        switch type {
        case .linkedin:
            let username =  lagostaInfos?.linkedinID ?? ""
            externalToolHandler.linkedinHandler.openLinkedin(with: username)
        case .medium:
            let urlMedium =  lagostaInfos?.mediumURL ?? ""
            externalToolHandler.mediumHandler.openMedium(with: urlMedium)
        case .youtube:
            let youtubeId = lagostaInfos?.youtubeID ?? ""
            externalToolHandler.youtubeHandler.openYoutube(with: youtubeId)
        case .telephone:
            let telephone = lagostaInfos?.phone ?? ""
            externalToolHandler.telephoneHandler.openTelephone(with: telephone, errorCompletion: {
                controller?.showErrorAlert(message: "Erro ao tentar fazer a ligação.")
            })
        case .whatsapp:
            let whatsapp = lagostaInfos?.whatsapp ?? ""
            externalToolHandler.whatsappHandler.openWhatsapp(with: whatsapp) {
                controller?.showErrorAlert(message: "Nenhum aplicativo de telefone encontrado")
            }
        }
    }
}

private extension ContactUsViewModel {
    func handleGetUserInfoResponse(with result: Result<Data, Error>) {
        controller?.stopLoading()
        switch result {
        case .success(let data):
            handleGetUserInfoSuccess(with: data)
        case .failure(let error):
            print("error api: \(error.localizedDescription)")
            controller?.showErrorAlert(message: "Erro ao receber os dados")
        }
    }
    
    func handleGetUserInfoSuccess(with data: Data) {
        let decoder = JSONDecoder()
        if let infos = try? decoder.decode(LagostaInfos.self, from: data) {
            self.lagostaInfos = infos
        } else {
            controller?.showErrorAlert(message: "Erro ao receber os dados. Tente novamente mais tarde")
        }
    }
    
    func handleSendMessageResponse(result: Result<Data, Error>) {
        controller?.stopLoading()
        switch result {
        case .success:
            controller?.didSendMessage()
        case .failure(let error):
            print("error api: \(error.localizedDescription)")
        }
    }
}
