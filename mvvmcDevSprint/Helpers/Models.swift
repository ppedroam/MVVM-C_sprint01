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
