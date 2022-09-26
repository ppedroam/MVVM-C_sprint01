//
//  Models.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 22/09/22.
//

import Foundation

struct Session: Codable {
    let id: String
    let token: String
}

struct User: Codable {
    var id: String = ""
    var email: String = ""
    var documentType: String = ""
    var phoneNumber: String = ""
    var name: String = ""
    var document: String = ""
    var password: String = ""
}

struct ContactUsModel: Codable {
    let whatsapp: String
    let phone: String
    let mail: String
}

struct LagostaInfos: Codable {
    let whatsapp: String
    let phone: String
    let youtubeID: String
    let linkedinID: String
    let mediumURL: String
    let mail: String
    
    static func create() -> LagostaInfos {
        let lagostaInfos = LagostaInfos(whatsapp: "888686868686",
                                        phone: "878878787878",
                                        youtubeID: "UCMA72bNWUzFlTODN63ovYTw",
                                        linkedinID: "pedro-araujo-menezes/",
                                        mediumURL: "https://ppedroam.medium.com",
                                        mail: "lagosta@devpass.com.br")
        return lagostaInfos
    }
}
