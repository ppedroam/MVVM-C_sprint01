//
//  GPLoginView.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 26/09/22.
//

import Foundation
import UIKit

class GPLoginView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let vc = UIScrollView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = .black
        vc.isScrollEnabled = true
        return vc
    }()
    
    lazy var logo: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "brain")
        img.tintColor = .blue
        return img
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailComponent: EmailComponent = {
        let component = EmailComponent()
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    lazy var passwordComponent: PasswordComponent = {
        let component = PasswordComponent()
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("ENTRAR", for: .normal)
        button.layer.cornerRadius = 24
        return button
    }()
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("CRIAR UMA CONTA", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        return button
    }()
    
    lazy var errorMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "mensagem de erro"
        label.isHidden = true
        label.textColor = .white
        return label
    }()
    
    func setupView() {
        backgroundColor = .white
        addComponents()
        configureComponent()
        makeConstraints()
    }
    
    private func addComponents() {
        addSubview(scrollView)
        
        scrollView.addSubview(logo)
        scrollView.addSubview(emailComponent)
        scrollView.addSubview(passwordComponent)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(createAccountButton)
        scrollView.addSubview(errorMessage)
    }

    private func configureComponent() {
        emailComponent.setComponent()
        passwordComponent.setComponent()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            logo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            logo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.heightAnchor.constraint(equalToConstant: 75),
            
            errorMessage.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 20),
            errorMessage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            emailComponent.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50),
            emailComponent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            emailComponent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            emailComponent.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            passwordComponent.topAnchor.constraint(equalTo: emailComponent.bottomAnchor, constant: 20),
            passwordComponent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            passwordComponent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            passwordComponent.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordComponent.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            createAccountButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80),
            createAccountButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            createAccountButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            createAccountButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func showMessageError(state: Bool) {
        errorMessage.isHidden = state
    }
}
