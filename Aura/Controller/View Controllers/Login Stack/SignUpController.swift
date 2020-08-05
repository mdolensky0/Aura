//
//  SignUpController.swift
//  Aura
//
//  Created by Max Dolensky on 8/4/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    var emailTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        return textField
        
    }()
    
    var passwordTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        return textField
        
    }()
    
    var reTypePasswordTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Retype password"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        return textField
        
    }()
    
    var signUpButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.styleFilledButton(fillColor: K.Colors.purple)
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
        
    }()
    
    var errLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        return label
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        
        emailTextField.styleTextFieldWithUnderline(ofColor: K.Colors.purple)
        passwordTextField.styleTextFieldWithUnderline(ofColor: K.Colors.purple)
        reTypePasswordTextField.styleTextFieldWithUnderline(ofColor: K.Colors.purple)
        
    }
    
    func setup() {
        
        view.backgroundColor = .white
        
        setupToHideKeyboardOnTapOnView()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        errLabel.isHidden = true
        
        let container = UIView()
        container.addSubview(emailTextField)
        container.addSubview(passwordTextField)
        container.addSubview(reTypePasswordTextField)
        container.addSubview(signUpButton)
        container.addSubview(errLabel)
        
        emailTextField.anchor(top: container.topAnchor,
                              bottom: nil,
                              leading: container.leadingAnchor,
                              trailing: container.trailingAnchor,
                              height: 40,
                              width: nil)
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor,
                                 bottom: nil,
                                 leading: container.leadingAnchor,
                                 trailing: container.trailingAnchor,
                                 height: 40,
                                 width: nil,
                                 padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        reTypePasswordTextField.anchor(top: passwordTextField.bottomAnchor,
                                       bottom: nil,
                                       leading: container.leadingAnchor,
                                       trailing: container.trailingAnchor,
                                       height: 40,
                                       width: nil,
                                       padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        signUpButton.anchor(top: reTypePasswordTextField.bottomAnchor,
                            bottom: nil,
                            leading: container.leadingAnchor,
                            trailing: container.trailingAnchor,
                            height: 50,
                            width: nil,
                            padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        
        errLabel.anchor(top: signUpButton.bottomAnchor,
                        bottom: container.bottomAnchor,
                        leading: container.leadingAnchor,
                        trailing: container.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        
    }
    
    @objc func signUpPressed() {
        
        // Get email, password, and retyped password
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let rePassword = reTypePasswordTextField.text else {
                
                showError("Error retrieving input, try again")
                return
                
        }
        
        // Check that all fields are filled out
        if email.count == 0 || password.count == 0 || rePassword.count == 0 {
            
            showError("Please fill out all fields")
            return
            
        }
        
        // Check for a valid email
        if !Utilities.shared.isEmailValid(email) {
            showError("Invalid Email. Please check that the email you entered is a valid email address")
            return
            
        }
        
        // Check for a valid password
        if !Utilities.shared.isPasswordValid(password) {
            
            showError("Password must contain at least 8 characters, one alphabet character, and one special character [A-Z, a-z, 0-9, !@#$%&*?]")
            return
            
        }
        
        // Make sure passwords match
        if password != rePassword {
            
            showError("Passwords do not match")
            return
            
        }
        
        // Sign In
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                
                self.showError(error.localizedDescription)
                return
                
            }
            
            self.errLabel.isHidden = true
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.reTypePasswordTextField.text = ""
            
            Utilities.shared.isUserSignedIn = true
            
            guard let tabBarController = self.tabBarController as? TabBarController else { return }
            tabBarController.userSignedIn()
            
        }
    }
    
    
    func showError(_ message: String) {
        
        errLabel.text = message
        errLabel.isHidden = false
        
    }
    
}
