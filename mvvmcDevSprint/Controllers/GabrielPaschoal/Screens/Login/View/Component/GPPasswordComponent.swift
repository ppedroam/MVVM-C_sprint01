//
//  PasswordComponent.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 26/09/22.
//

import Foundation
import UIKit

class GPPasswordComponent: UIView {
    
    var showPasswordState = false
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Senha"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var passwordTextField: GPCustomTextField = {
        let textField = GPCustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6
        textField.placeholder = "Senha"
        textField.placeholderRect(forBounds: CGRect(x: 5, y: 0, width: frame.width, height: frame.height))
        return textField
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let component = UIButton()
        component.translatesAutoresizingMaskIntoConstraints = false
        component.setTitle("Esqueceu sua senha?", for: .normal)
        component.tintColor = .lightGray
        return component
    }()
    
    lazy var showPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    func setComponent() {
        hierarchy()
        passwordTextField.returnKeyType = .done
        showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
    }
    
    func hierarchy() {
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(showPasswordButton)
        addSubview(forgotPasswordButton)
        makeConstraints()
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: topAnchor),
            passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            showPasswordButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -16),
            showPasswordButton.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            forgotPasswordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
        ])
    }
    
    @objc func showPassword() {
        if(showPasswordState == true) {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage.init(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage.init(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        showPasswordState = !showPasswordState
    }
}

