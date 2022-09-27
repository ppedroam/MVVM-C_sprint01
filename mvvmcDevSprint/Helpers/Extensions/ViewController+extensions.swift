//
//  ViewController+extensions.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 22/09/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoading() {
        let loadingController = LoadingController()
        loadingController.modalPresentationStyle = .fullScreen
        loadingController.modalTransitionStyle = .crossDissolve
        self.present(loadingController, animated: true)
    }

    func stopLoading() {
        if let presentedController = presentedViewController as? LoadingController {
            presentedController.dismiss(animated: true)
        }
    }
    
    func showAlertDialog(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actin = UIAlertAction(title: buttonTitle, style: .default)
        alertController.addAction(actin)
        present(alertController, animated: true)
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
