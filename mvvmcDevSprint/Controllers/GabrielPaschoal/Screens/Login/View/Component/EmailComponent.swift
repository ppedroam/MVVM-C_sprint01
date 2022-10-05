//
//  EmailComponent.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 26/09/22.
//

import Foundation
import UIKit

class EmailComponent: UIView {
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "E-mail"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6
        textField.placeholder = "E-mail"
        textField.placeholderRect(forBounds: CGRect(x: 5, y: 0, width: frame.width, height: frame.height))
        return textField
    }()
    
    func setComponent() {
        hierarchy()
        emailTextField.returnKeyType = .next
    }
    
    func hierarchy() {
        addSubview(emailLabel)
        addSubview(emailTextField)
        makeConstraints()
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: topAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            emailTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}
