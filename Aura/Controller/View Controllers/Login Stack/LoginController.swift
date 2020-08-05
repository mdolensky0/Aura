//
//  LoginController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    var auraLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        
        let title = NSMutableAttributedString(string: "Aura")
        title.addAttribute(.foregroundColor, value: K.Colors.purple, range: NSRange(location: 0, length: 2))
        title.addAttribute(.foregroundColor, value: K.Colors.darkGrey, range: NSRange(location: 2, length: 1))
        title.addAttribute(.foregroundColor, value: K.Colors.lightPink, range: NSRange(location: 3, length: 1))
        
        label.attributedText = title

        return label
        
    }()
    
    var signUpButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.styleFilledButton(fillColor: K.Colors.purple)
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
        
    }()
    
    var logInButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.styleHollowbutton(outlineColor: .black)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        let container = UIView()
        
        container.addSubview(auraLabel)
        container.addSubview(signUpButton)
        container.addSubview(logInButton)
        
        auraLabel.anchor(top: container.topAnchor,
                         bottom: nil,
                         leading: container.leadingAnchor,
                         trailing: container.trailingAnchor,
                         height: nil,
                         width: nil)
        
        signUpButton.anchor(top: auraLabel.bottomAnchor,
                            bottom: nil,
                            leading: container.leadingAnchor,
                            trailing: container.trailingAnchor,
                            height: 50,
                            width: nil,
                            padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        
        logInButton.anchor(top: signUpButton.bottomAnchor,
                           bottom: container.bottomAnchor,
                           leading: container.leadingAnchor,
                           trailing: container.trailingAnchor,
                           height: 50,
                           width: nil,
                           padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        
                
    }
    
    @objc func signUpPressed() {
        
        let signUpVC = SignUpController()
        
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    @objc func logInPressed() {
        
        let logInVC = SignInController()
        
        self.navigationController?.pushViewController(logInVC, animated: true)
        
    }
    
}
