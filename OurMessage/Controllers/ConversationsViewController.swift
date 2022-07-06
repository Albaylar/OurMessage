//
//  ConversationsViewController.swift
//  OurMessage
//
//  Created by Furkan Deniz Albaylar on 6.07.2022.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isLoggedin = UserDefaults.standard.bool(forKey: "Logged_in")
        
        if !isLoggedin {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }

}

