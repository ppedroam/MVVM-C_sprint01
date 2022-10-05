//
//  ButtonComponent.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 28/09/22.
//

import Foundation
import UIKit

class GPButtonComponent: UIView {
    
    lazy var buttonComponent: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.layer.cornerRadius = 24
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.blue.cgColor
        return btn
    }()
    
    func render() {
        buildHierarchy()
    }
    
    private func buildHierarchy() {
        addSubview(buttonComponent)
        makeContraints()
    }
    
    private func makeContraints() {
        NSLayoutConstraint.activate([
            buttonComponent.topAnchor.constraint(equalTo: topAnchor),
            buttonComponent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonComponent.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonComponent.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonComponent.heightAnchor.constraint(equalToConstant: 46),
        ])
    }
}

extension GPButtonComponent {
    func setButtonTitle(title: String) {
        buttonComponent.setTitle(title, for: .normal)
    }
    
    func setImage(img: UIImage) {
        buttonComponent.setImage(img, for: .normal)
    }
    
    func buttonIsEnabled(state: Bool) {
        if !state {
            disabledState()
        }
        defaultState()
    }
    
    func defaultState() {
        buttonComponent.isEnabled = true
        buttonComponent.backgroundColor = .white
        buttonComponent.layer.borderColor = UIColor.blue.cgColor
        buttonComponent.setTitleColor(.blue, for: .normal)
    }
    
    func disabledState() {
        buttonComponent.isEnabled = false
        buttonComponent.backgroundColor = .gray
        buttonComponent.layer.borderColor = UIColor.gray.cgColor
        buttonComponent.setTitleColor(.white, for: .normal)
    }
}
