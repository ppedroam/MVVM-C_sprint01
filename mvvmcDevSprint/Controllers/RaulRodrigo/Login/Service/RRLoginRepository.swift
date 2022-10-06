//
//  RRLoginService.swift
//  mvvmcDevSprint
//
//  Created by Raul Rodrigo on 26/09/22.
//

import Foundation

protocol RRLoginRepositoryProtocol{
    func isLogged() -> Bool    
}

class RRLoginRepository: RRLoginRepositoryProtocol {
    func isLogged() -> Bool {
        return UserDefaultsManager.UserInfos.shared.readSesion() != nil ? true : false
    }
}
