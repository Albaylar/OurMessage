//
//  LoginViewController.swift
//  OurMessage
//
//  Created by Furkan Deniz Albaylar on 6.07.2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .continue
        Field.layer.cornerRadius = 12
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.lightGray.cgColor
        Field.placeholder = "Enter a email"
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        Field.leftViewMode = .always
        Field.backgroundColor = .white
        return Field
    }()
    private let passwordField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .done
        Field.layer.cornerRadius = 12
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.lightGray.cgColor
        Field.placeholder = "password"
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        Field.leftViewMode = .always
        Field.backgroundColor = .white
        Field.isSecureTextEntry = true
        return Field
    }()
    
    private let imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = (UIImage(named: "logo"))
        imageView.contentMode =  .scaleAspectFit
        return imageView
    }()
    
    private let LoginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return button
        
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done, target: self ,
                                                            action: #selector(didTapRegister))
        
        LoginButton.addTarget(self, action:#selector(loginButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(LoginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                 height: 52)
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom+10,
                                  width: scrollView.width-60,
                                 height: 52)
        LoginButton.frame = CGRect(x: 30,
                                  y: passwordField.bottom+20,
                                  width: scrollView.width-60,
                                 height: 45)
        
    }
    @objc private func loginButtonTapped(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty , password.count >= 6 else {
                alertUserLoginError()
                return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self]authResult, error in
            guard let StrongSelf = self else{
                return
            }
        guard let result = authResult, error == nil     else{
            print("Failed to login user with email : \(email)")
            return
        }
            let user = result.user
            print("Logged in User : \(user)")
            StrongSelf.navigationController?.dismiss(animated: true, completion: nil)
    })
}
        
    func alertUserLoginError(){
        let alert = UIAlertController(title: " ooopsss!! ",
                                      message: "You should enter all informations correctly.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismis",
                                      style: .cancel,
                                      handler: nil))
            
        
            present(alert, animated: true)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc .title = "Create a account"
        navigationController?.pushViewController(vc, animated: true)
    }
}
    extension LoginViewController: UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            if textField == emailField {
                passwordField.becomeFirstResponder()
            }
            else if textField == passwordField{
                loginButtonTapped()
            }
            
            return true
        }
        
    }

