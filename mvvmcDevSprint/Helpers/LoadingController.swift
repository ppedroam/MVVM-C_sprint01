//
//  LoadingController.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 22/09/22.
//

import Foundation
import UIKit

class LoadingController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let loading = UIActivityIndicatorView(style: .large)
        view.addSubview(loading)
        loading.startAnimating()
        loading.color = .white
        view.backgroundColor = .black
        loading.center = view.center
    }
}
