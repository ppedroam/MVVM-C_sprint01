//
//  RRLoginService.swift
//  mvvmcDevSprint
//
//  Created by Raul Rodrigo on 26/09/22.
//

import Foundation

protocol RRLoginRepositoryProtocol{
    func isLogged() -> Bool
    func isWithOutConnection() -> Bool
    
}


class RRLoginRepository: RRLoginRepositoryProtocol {
    func isWithOutConnection() -> Bool {
        return !ConnectivityManager.shared.isConnected
    }
    
    
    func isLogged() -> Bool {
        return UserDefaultsManager.UserInfos.shared.readSesion() != nil ? true : false
    }
    
    
}
