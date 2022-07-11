//
//  ConversationsViewController.swift
//  OurMessage
//
//  Created by Furkan Deniz Albaylar on 6.07.2022.
//

import UIKit
import FirebaseAuth
class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    private  func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: false)
            }
            
            
        
        
    }
    }


