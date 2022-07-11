//
//  RegisterViewController.swift
//  OurMessage
//
//  Created by Furkan Deniz Albaylar on 6.07.2022.
//

import UIKit
import FirebaseAuth

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
        imageView.image = (UIImage(systemName: "person.circle.fill"))
        imageView.tintColor = .gray
        imageView.contentMode =  .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
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
        PresentPhotoActionSheet()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        
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
        
        
        
        DataBaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self  else {
                return
            }
            guard !exists else {
                // user already exists
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists.")
                return
            }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            guard authResult != nil, error == nil   else{
            print("Error creating user")
            return
            }
            
            
            DataBaseManager.shared.insertUser(with: ChatAppUser( firstName: firstName,                                                                                              lastName: LastName,
                                                                emailAdress: email))
            
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    })
}
        
    func alertUserLoginError(message : String = "You should enter all informations correctly to create a new account."){
        let alert = UIAlertController(title: " ooopsss!! ",
                                      message: message,
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

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func PresentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile picture",
                                            message: "Select a picture",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
    
        actionSheet.addAction(UIAlertAction(title: "Take Photo ",
                                        style: .default,
                                        handler:{ [weak self]_ in
            
                                        self?.presentCamera()
        
        }))

        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                    style: .default,
                                    handler:{ [weak self]_ in
            
                                        self?.prensentPhotoPicker()
    
        }))
        
        present(actionSheet, animated: true)
}
    
        
        func presentCamera(){
            
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
            
        }
        func prensentPhotoPicker(){
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
            
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }

}
