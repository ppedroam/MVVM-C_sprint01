//
//  ResetPasswordEmailComponent.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 28/09/22.
//

import Foundation
import UIKit

class GPResetPasswordEmailComponent: UIView {
    
    lazy var emailLabel: UILabel = {
        let text = UILabel()
        text.text = "Informe o seu email associado a sua conta"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .gray
        text.textAlignment = .center
        return text
    }()
    
    lazy var emailTextField: GPCustomTextField = {
        let textField = GPCustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6
        textField.placeholder = "E-mail"
        textField.placeholderRect(forBounds: CGRect(x: 5, y: 0, width: frame.width, height: frame.height))
        return textField
    }()
    
    func render() {
        buildHierarchy()
    }
    
    private func buildHierarchy() {
        addSubview(emailLabel)
        addSubview(emailTextField)
        makeContraints()
    }
    
    private func makeContraints() {
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: topAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emailTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}

extension GPResetPasswordEmailComponent {
    func setTitleLabel(title: String) {
        emailLabel.text = title
    }
    
    func buttonIsEnabled(state: Bool) {
        if !state {
            errorState()
        }
        defaultState()
    }
    
    func defaultState() {
        emailTextField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func errorState() {
        emailTextField.layer.borderColor = UIColor.red.cgColor
    }
}
