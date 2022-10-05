//
//  GPResetPasswordView.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 28/09/22.
//

import Foundation
import UIKit

class GPResetPasswordView: UIView {
    lazy var closeButton: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "xmark.app.fill")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var logo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "smoke.fill")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var boxResetEmail: GPResetPasswordEmailComponent = {
        let box = GPResetPasswordEmailComponent()
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()
    
    lazy var recoverPasswordButton: GPButtonComponent = {
        let btn = GPButtonComponent()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var loginButton: GPButtonComponent = {
        let btn = GPButtonComponent()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var needHelpButton: GPButtonComponent = {
        let btn = GPButtonComponent()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var createAnotherAccountButton: GPButtonComponent = {
        let btn = GPButtonComponent()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func render() {
        buildHierarchy()
        recoverPasswordButton.render()
        boxResetEmail.render()
        loginButton.render()
        needHelpButton.render()
        createAnotherAccountButton.render()
        recoverPasswordButton.disabledState()
        recoverPasswordButton.setButtonTitle(title: "RECUPERAR SENHA")
        loginButton.setButtonTitle(title: "LOGIN")
        needHelpButton.setButtonTitle(title: "PRECISAR DE AJUDA")
        createAnotherAccountButton.setButtonTitle(title: "CRIAR UMA  CONTA")
    }
    
    private func buildHierarchy() {
        addSubview(closeButton)
        addSubview(logo)
        addSubview(boxResetEmail)
        addSubview(needHelpButton)
        addSubview(loginButton)
        addSubview(recoverPasswordButton)
        addSubview(createAnotherAccountButton)
        makeContraints()
    }
    
    private func makeContraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            
            logo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            logo.centerXAnchor.constraint(equalTo: centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.heightAnchor.constraint(equalToConstant: 75),
            
            boxResetEmail.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50),
            boxResetEmail.centerXAnchor.constraint(equalTo: centerXAnchor),
            boxResetEmail.leadingAnchor.constraint(equalTo: leadingAnchor),
            boxResetEmail.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            recoverPasswordButton.topAnchor.constraint(equalTo: boxResetEmail.bottomAnchor, constant: 15),
            recoverPasswordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            recoverPasswordButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recoverPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            loginButton.topAnchor.constraint(equalTo: recoverPasswordButton.bottomAnchor, constant: 84),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            needHelpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            needHelpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            needHelpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            needHelpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            createAnotherAccountButton.topAnchor.constraint(equalTo: needHelpButton.bottomAnchor, constant: 15),
            createAnotherAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createAnotherAccountButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            createAnotherAccountButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
}
