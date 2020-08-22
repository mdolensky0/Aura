//
//  SignInController.swift
//  Aura
//
//  Created by Max Dolensky on 8/4/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController {

    var isModal = false
    var delegate: AddFlashcardDelegate?
    var emailTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.text = "imadethis@cox.net"
        return textField
        
    }()
    
    var passwordTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.text = "lakikikI*1"
        return textField
        
    }()
    
    var logInButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.styleFilledButton(fillColor: K.Colors.lightPink)
        button.addTarget(self, action: #selector(logInPressed(_:)), for: .touchUpInside)
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
                
        emailTextField.styleTextFieldWithUnderline(ofColor: K.Colors.lightPink)
        passwordTextField.styleTextFieldWithUnderline(ofColor: K.Colors.lightPink)
        
    }
        
    func setup() {
        
        view.backgroundColor = .white
        
        setupToHideKeyboardOnTapOnView()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        errLabel.isHidden = true
        
        let container = UIView()
        container.addSubview(emailTextField)
        container.addSubview(passwordTextField)
        container.addSubview(logInButton)
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
                
        logInButton.anchor(top: passwordTextField.bottomAnchor,
                            bottom: nil,
                            leading: container.leadingAnchor,
                            trailing: container.trailingAnchor,
                            height: 50,
                            width: nil,
                            padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        
        errLabel.anchor(top: logInButton.bottomAnchor,
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
    
    @objc func logInPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        }) { (completion) in
            
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
            
        }
        
        // Get email and password
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            
            showError("Error retrieving input")
            return
            
        }
        
        // Check that all fields are filled out
        if email.count == 0 || password.count == 0 {
            
            showError("Please fill out all fields")
            
        }
        
        // Start Loading Screen
        DispatchQueue.main.async {
            self.startLoadingScreen()
        }
        
        // Sign In
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                }
                self.showError(error.localizedDescription)
                return
                
            }
            
            self.errLabel.isHidden = true
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
            Utilities.shared.isUserSignedIn = true
            
            FirebaseManager.shared.loadUser { (user) in
                
                if let user = user {
                    
                    Utilities.shared.user = user
                    
                }
                
                else {
                    
                    FirebaseManager.shared.createUser()

                }
                
            }
            
            if self.isModal {
            
                guard let tabBarController = self.presentingViewController as? TabBarController else {
                    DispatchQueue.main.async {
                        self.endLoadingScreen()
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                }
                tabBarController.userSignedIn()
                self.dismiss(animated: true, completion: nil)
                self.delegate?.tapAddFlashcardButton()
            }
                
            else {
                
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                }
                guard let tabBarController = self.tabBarController as? TabBarController else { return }
                tabBarController.userSignedIn()
            }
            
        }
    }
    
    
    func showError(_ message: String) {
        
        errLabel.text = message
        errLabel.isHidden = false
        
    }
    
}
