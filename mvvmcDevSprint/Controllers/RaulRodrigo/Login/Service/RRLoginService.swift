//
//  RRLoginService.swift
//  mvvmcDevSprint
//
//  Created by Raul Rodrigo on 26/09/22.
//

import Foundation

protocol RRLoginServiceProtocol{
    func isLogged() -> Bool
    
}

class RRLoginService {
    
}

extension RRLoginService: RRLoginServiceProtocol {
    
    func isLogged() -> Bool {
        return UserDefaultsManager.UserInfos.shared.readSesion() != nil ? true : false
    }
    
    
}
