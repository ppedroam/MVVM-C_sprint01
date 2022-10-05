//
//  CustomTextField.swift
//  mvvmcDevSprint
//
//  Created by Gabriel Paschoal on 26/09/22.
//

import Foundation
import UIKit

class GPCustomTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func resetError(hasError: Bool) {
        if hasError {
            self.setErrorColor()
        } else {
            self.setDefaultColor()
        }
    }
}
