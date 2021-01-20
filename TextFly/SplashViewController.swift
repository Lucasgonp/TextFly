//
//  SplashViewController.swift
//  TextFly
//
//  Created by Lucas Pereira on 18/01/21.
//

import UIKit

class SplashViewController: UIViewController {

    var isLoggedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        if !isLoggedIn {
            let controller = LoginViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
    }
    
}

