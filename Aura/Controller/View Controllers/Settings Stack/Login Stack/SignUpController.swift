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
    
    var isModal = false
    var delegate: AddFlashcardDelegate?
    
    var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        label.backgroundColor = .clear
        label.font = UIFont(name: K.Fonts.avenirBlack, size: 15)
        label.text = "Sign Up"
        label.numberOfLines = 2
        label.textColor = .black
        label.textAlignment = .center
        return label
        
    }()
    
    var auraLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        
        let title = NSMutableAttributedString(string: "Aura")
        title.addAttribute(.foregroundColor, value: K.Colors.purple, range: NSRange(location: 0, length: 2))
        title.addAttribute(.foregroundColor, value: K.Colors.darkGrey, range: NSRange(location: 2, length: 1))
        title.addAttribute(.foregroundColor, value: K.Colors.lightPink, range: NSRange(location: 3, length: 1))
        
        label.attributedText = title

        return label
        
    }()
    
    var emailTextField: UITextField = {
        
        let textField = UITextFieldPadding()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        textField.roundCorners(cornerRadius: 4)
        textField.textColor = .black
        textField.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textField.placeholder = "Email"
        textField.setBorder(color: K.Colors.purple)
        
        return textField
        
    }()
    
    var passwordTextField: UITextField = {
        
        let textField = UITextFieldPadding()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        textField.roundCorners(cornerRadius: 4)
        textField.textColor = .black
        textField.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textField.placeholder = "Password"
        textField.setBorder(color: K.Colors.purple)
        textField.isSecureTextEntry = true
        return textField
        
    }()
    
    var passwordRequirementsLabel: UILabel = {
        
        let l = UILabel()
        l.text = "Password must be 8 characters long"
        l.textAlignment = .center
        l.backgroundColor = .white
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return l
        
    }()
    
    var userAgreementLabel: UILabel = {
        
        let l = UILabel()
        
        let attText = NSMutableAttributedString(string: "By creating an account you're agreeing to our Terms & Privacy Policy")
        attText.addAttribute(.foregroundColor, value: K.Colors.purple, range: NSRange(location: 46, length: 5))
        attText.addAttribute(.foregroundColor, value: K.Colors.purple, range: NSRange(location: 54, length: 14))
        attText.addAttribute(.font, value: UIFont.systemFont(ofSize: 13), range: NSRange(location: 0, length: attText.length))
        l.attributedText = attText
        l.textAlignment = .center
        l.backgroundColor = .white
        l.numberOfLines = 0
        return l
        
    }()
    
    var reTypePasswordTextField: UITextField = {
        
        let textField = UITextFieldPadding()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        textField.roundCorners(cornerRadius: 4)
        textField.textColor = .black
        textField.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textField.placeholder = "Retype Password"
        textField.setBorder(color: K.Colors.purple)
        textField.isSecureTextEntry = true
        return textField
        
    }()
    
    var signUpButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.styleFilledButton(fillColor: K.Colors.purple)
        button.addTarget(self, action: #selector(signUpPressed(_:)), for: .touchUpInside)
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
            
    func setup() {
        
        view.backgroundColor = .white
        
        // Add Center Title
        self.navigationItem.titleView = titleLabel
        
        setupToHideKeyboardOnTapOnView()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.topItem?.title = " "
        errLabel.isHidden = true
        
        if isModal {
            
            // Add cancel button
            if #available(iOS 13.0, *) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                                         style: .plain,
                                                                         target: self,
                                                                         action: #selector(cancelButtonTapped))
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "multiply").withRenderingMode(.alwaysTemplate),
                                                                         style: .plain,
                                                                         target: self,
                                                                         action: #selector(cancelButtonTapped))
            }
            
        }
        
        view.addSubview(auraLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordRequirementsLabel)
        view.addSubview(reTypePasswordTextField)
        view.addSubview(userAgreementLabel)
        view.addSubview(signUpButton)
        view.addSubview(errLabel)
        
        auraLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: nil,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0))
        
        emailTextField.anchor(top: auraLabel.bottomAnchor,
                              bottom: nil,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              height: 40,
                              width: nil,
                              padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: -30))
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor,
                                 bottom: nil,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 height: 40,
                                 width: nil,
                                 padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: -30))
        
        passwordRequirementsLabel.anchor(top: passwordTextField.bottomAnchor,
                                         bottom: nil,
                                         leading: view.leadingAnchor,
                                         trailing: view.trailingAnchor,
                                         height: nil,
                                         width: nil,
                                         padding: UIEdgeInsets(top: 8, left: 30, bottom: 0, right: -30))
        
        reTypePasswordTextField.anchor(top: passwordRequirementsLabel.bottomAnchor,
                                       bottom: nil,
                                       leading: view.leadingAnchor,
                                       trailing: view.trailingAnchor,
                                       height: 40,
                                       width: nil,
                                       padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: -30))
                
        signUpButton.anchor(top: reTypePasswordTextField.bottomAnchor,
                            bottom: nil,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            height: 50,
                            width: nil,
                            padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: -30))
        
        userAgreementLabel.anchor(top: signUpButton.bottomAnchor,
                                  bottom: nil,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  height: nil,
                                  width: nil,
                                  padding: UIEdgeInsets(top: 12, left: 60, bottom: 0, right: -60))
        
        errLabel.anchor(top: userAgreementLabel.bottomAnchor,
                        bottom: nil,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 12, left: 40, bottom: -20, right: -40))
        
    }
    
    @objc func signUpPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        }) { (completion) in
            
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
            
        }
        
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
            
            showError("Password must contain at least 8 characters")
            return
            
        }
        
        // Make sure passwords match
        if password != rePassword {
            
            showError("Passwords do not match")
            return
            
        }
        
        DispatchQueue.main.async {
            self.startLoadingScreen()
        }
        
        // Sign In
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                
                self.showError(error.localizedDescription)
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                }
                return
                
            }
            
            self.errLabel.isHidden = true
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.reTypePasswordTextField.text = ""
            
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
    
    @objc func cancelButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func showError(_ message: String) {
        
        errLabel.text = message
        errLabel.isHidden = false
        
    }
    
}
