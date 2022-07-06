//
//  RegisterViewController.swift
//  OurMessage
//
//  Created by Furkan Deniz Albaylar on 6.07.2022.
//

import UIKit

class RegisterViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let FirstNameField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .continue
        Field.layer.cornerRadius = 12
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.lightGray.cgColor
        Field.placeholder = "Enter a First Name "
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        Field.leftViewMode = .always
        Field.backgroundColor = .white
        return Field
    }()
    
    private let LastNameField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .continue
        Field.layer.cornerRadius = 12
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.lightGray.cgColor
        Field.placeholder = "Enter a Last Name "
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        Field.leftViewMode = .always
        Field.backgroundColor = .white
        return Field
    }()
    
    private let emailField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .continue
        Field.layer.cornerRadius = 12
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.lightGray.cgColor
        Field.placeholder = "Enter a your Email "
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
        imageView.image = (UIImage(systemName: "person"))
        imageView.tintColor = .gray
        imageView.contentMode =  .scaleAspectFit
        return imageView
    }()
    
    private let RegisterButton : UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return button
        
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done, target: self ,
                                                            action: #selector(didTapRegister))
        
        RegisterButton.addTarget(self, action:#selector(RegisterButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(FirstNameField)
        scrollView.addSubview(LastNameField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(RegisterButton)
        scrollView.addSubview(emailField)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePicture))

        imageView.addGestureRecognizer(gesture)
    }
    @objc private func didTapChangeProfilePicture(){
        print("Change a profile picture")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        FirstNameField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        LastNameField.frame = CGRect(x: 30,
                                  y: FirstNameField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        emailField.frame = CGRect(x: 30,
                                  y: LastNameField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        RegisterButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom+20,
                                   width: scrollView.width-60,
                                   height: 45)
        
    }
    @objc private func RegisterButtonTapped(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        FirstNameField.resignFirstResponder()
        LastNameField.resignFirstResponder()
        
        guard  let firstName = FirstNameField.text,
               let LastName = LastNameField.text,
               let email = emailField.text,
               let password = passwordField.text,
               !firstName.isEmpty,
               !LastName.isEmpty ,
               !email.isEmpty,
               !password.isEmpty,
                password.count >= 6
        else {
            alertUserLoginError()
            return
        }
        
        // Firebase Login
        
    }
    func alertUserLoginError(){
        let alert = UIAlertController(title: " ooopsss!! ",
                                      message: "You should enter all informations correctly to create a new account.",
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
extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            RegisterButtonTapped()
        }
        
        return true
    }
    
}

