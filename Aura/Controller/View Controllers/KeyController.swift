//
//  KeyController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class KeyController: UIViewController {
    
    var centerTitle: UILabel = {
       
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.backgroundColor = K.Colors.purple
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "English HD Key"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var mainScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = K.Colors.lightGrey
        return scrollView
        
    }()
        
    var mainStackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        return stackView
        
    }()
    
    var fullKeyView = FullKeyView()
    
    // Vowel Explanation View
    let vowelKey: ColorKeyView = {
        
        let keyView = ColorKeyView(frame: .zero,
                                   title: "Vowels",
                                   explanation: "Each color represents a single vowel sound that a letter or combination of letter can make",
                                   numRows: 5,
                                   numCol: 3,
                                   cornerRadius: 0,
                                   colors: [K.Colors.green,      K.Colors.red,       K.Colors.blue,
                                            K.Colors.lightGreen, K.Colors.lightPink, K.Colors.lightBlue,
                                            K.Colors.seaBlue,    K.Colors.orange,    .white,
                                            K.Colors.darkGreen,  K.Colors.pink,      K.Colors.darkBlue,
                                            .white,              K.Colors.purple,    K.Colors.turquoise])
        
        keyView.explanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        keyView.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return keyView
        
    }()
    
    // True Consonants Explanation View
    let trueConsonantsKey: ColorKeyView = {
        
        let keyView = ColorKeyView(frame: .zero,
                                   title: "True Consonants",
                                   explanation: "Most consonants in English are associated with a unique sound. Black letters or letter combinations represent our textbook understanding of what a consonant letter sounds like",
                                   numRows: 1,
                                   numCol: 1,
                                   cornerRadius: 0,
                                   colors: [.black])
        
        keyView.explanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        keyView.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return keyView
        
    }()
    
    // Flip Consonants Explanation View
    let flipConsonantsKey: ColorKeyView = {
        
        let keyView = ColorKeyView(frame: .zero,
                                   title: "Flip Consonants",
                                   explanation: "Some consonants in English have a secondary sound associated with them which we refer to as the \"flip\" sound. Gray letters or letter combinations represent this \"flip\" sound.",
                                   numRows: 1,
                                   numCol: 1,
                                   cornerRadius: 0,
                                   colors: [K.Colors.darkGrey])
        
        keyView.explanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        keyView.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return keyView
        
    }()
    
    // Fluid Consonants Explanation View
    let fluidConsonantsKey: ColorKeyView = {
        
        let keyView = ColorKeyView(frame: .zero,
                                   title: "Fluid Consonants",
                                   explanation: "Certain consonant sounds do not have a dedicated letter to represent them. Each of these colors represents a specific consonant sound, regardless of the letter or letter combination",
                                   numRows: 3,
                                   numCol: 2,
                                   cornerRadius: 0,
                                   colors: [K.Colors.brownPurple, K.Colors.brownYellow,
                                            K.Colors.brownRed, K.Colors.tan,
                                            K.Colors.blueGrey, .white])
        
        keyView.explanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        keyView.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return keyView
    }()
    
    // Silent Explanation View
    let silentKey: ColorKeyView = {
        
        let keyView = ColorKeyView(frame: .zero,
                                   title: "Silent",
                                   explanation: "Light Gray indicated that the letter is silent and creates no sound in the particular word",
                                   numRows: 1,
                                   numCol: 1,
                                   cornerRadius: 0,
                                   colors: [K.Colors.lightGrey])
        
        keyView.explanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        keyView.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return keyView
        
    }()
    
    // Wildcard Explanation View
    let wildcardKey: ColorKeyView = {
        
        let keyView = ColorKeyView(frame: .zero,
                                   title: "Wildcards",
                                   explanation: "Some letters or letter combinations in English do not sound as they appear. Instead of adding additional colors to represent each of these sounds, yellow is used to represent all outliers. In a given word, tap the yellow to reveal the correct sound",
                                   numRows: 1,
                                   numCol: 1,
                                   cornerRadius: 0,
                                   colors: [K.Colors.yellow])
        
        keyView.explanationLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        keyView.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return keyView
        
    }()
        
    // Initialize Scroll Views
    let vowelScrollView = KeyCardScrollView(frame: .zero, K.KeyInfo.vowelSoundAndColor, nil, true)
    let fluidScrollView = KeyCardScrollView(frame: .zero, K.KeyInfo.fluidSoundAndColor, nil, true)
    let trueScrollView = KeyCardScrollView(frame: .zero, nil, K.KeyInfo.trueSoundAndText, true)
    let flipScrollView = KeyCardScrollView(frame: .zero, nil, K.KeyInfo.flipSoundAndText, false)
    let silentScrollView = KeyCardScrollView(frame: .zero, [("", K.Colors.lightGrey)], nil, true)
    let wildScrollView = KeyCardScrollView(frame: .zero, [("", K.Colors.yellow)], nil, true)
    
    let containerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        return view
        
    }()
    
    let keyTypeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Micro View"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.backgroundColor = .white
        return label
        
    }()
    
    let toggle: UISwitch = {
        
        let toggle = UISwitch()
        toggle.onTintColor = K.Colors.purple
        toggle.addTarget(self, action: #selector(togglePressed(_:)), for: .valueChanged)
        toggle.backgroundColor = .white
        return toggle
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = K.Colors.lightGrey
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        
        containerView.setShadow(color: .black, opacity: 0.5, offset: .zero, radius: 3)
        containerView.backgroundColor = .white
        
    }
    
    func setup() {
       
        // Setup Navigation Bar
        self.navigationItem.titleView = centerTitle
        
        // Add UserButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(profileButtonTapped))
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.Colors.purple
        
        // Add UISwitch and View Type Label
        containerView.addSubview(keyTypeLabel)
        containerView.addSubview(toggle)
        
        keyTypeLabel.anchor(top: containerView.topAnchor,
                            bottom: containerView.bottomAnchor,
                            leading: containerView.leadingAnchor,
                            trailing: nil,
                            height: nil,
                            width: nil,
                            padding: UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 0))
        
        toggle.anchor(top: containerView.topAnchor,
                      bottom: containerView.bottomAnchor,
                      leading: nil,
                      trailing: containerView.trailingAnchor,
                      height: nil,
                      width: nil,
                      padding: UIEdgeInsets(top: 10, left: 0, bottom: -10, right: -10))
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             bottom: nil,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             height: nil,
                             width: nil)
        
        // Add scroll view and Content view
        view.addSubview(mainScrollView)
        view.sendSubviewToBack(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        
        // Anchor Scroll View
        mainScrollView.anchor(top: containerView.bottomAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              height: nil,
                              width: nil)
        
        // Anchor Content View
        mainStackView.anchor(top: mainScrollView.topAnchor,
                             bottom: mainScrollView.bottomAnchor,
                             leading: mainScrollView.leadingAnchor,
                             trailing: mainScrollView.trailingAnchor,
                             height: nil,
                             width: nil)
        
        mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
        // Add Full Key to Stack View
        fullKeyView = FullKeyView(frame: .zero, width: view.frame.width)
        mainStackView.addArrangedSubview(fullKeyView)
        fullKeyView.isHidden = true
                
        // Create pointer from Color Key to its associated Key Card Scroll View
        vowelKey.myScrollView = vowelScrollView
        fluidConsonantsKey.myScrollView = fluidScrollView
        trueConsonantsKey.myScrollView = trueScrollView
        flipConsonantsKey.myScrollView = flipScrollView
        silentKey.myScrollView = silentScrollView
        wildcardKey.myScrollView = wildScrollView
        
        // Add Scroll Views to Main Stack View
        mainStackView.addArrangedSubview(vowelScrollView)
        mainStackView.addArrangedSubview(vowelKey)
        mainStackView.addArrangedSubview(fluidScrollView)
        mainStackView.addArrangedSubview(fluidConsonantsKey)
        mainStackView.addArrangedSubview(trueScrollView)
        mainStackView.addArrangedSubview(trueConsonantsKey)
        mainStackView.addArrangedSubview(flipScrollView)
        mainStackView.addArrangedSubview(flipConsonantsKey)
        mainStackView.addArrangedSubview(silentScrollView)
        mainStackView.addArrangedSubview(silentKey)
        mainStackView.addArrangedSubview(wildScrollView)
        mainStackView.addArrangedSubview(wildcardKey)
        
        // Constrain Scroll View width so that the prev and next cards show on the screen and the main stackView can adjust its size
        vowelScrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -160).isActive = true
        fluidScrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -160).isActive = true
        trueScrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -160).isActive = true
        flipScrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -160).isActive = true
        silentScrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -160).isActive = true
        wildScrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -160).isActive = true
        
        // Set widths of explanation keys so they strech the whole screen since alignment for stack view is center
        vowelKey.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        fluidConsonantsKey.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        trueConsonantsKey.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        flipConsonantsKey.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        silentKey.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        wildcardKey.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
    
    @objc func profileButtonTapped() {
        
        if Utilities.shared.isUserSignedIn {
            
            Utilities.shared.signUserOut(alertIn: self)
            
        }
        
        else {
            
            let vc = UINavigationController(rootViewController: LoginController())
            let login = vc.viewControllers[0] as! LoginController
            login.isModal = true
            self.present(vc, animated: true, completion: nil)
            
        }

    }
    
    @objc func togglePressed(_ sender: UISwitch) {
        
        if !sender.isOn {
            
            keyTypeLabel.text = "Micro View"
            
            fullKeyView.isHidden = true
            
            vowelScrollView.isHidden = false
            vowelKey.isHidden = false
            fluidScrollView.isHidden = false
            fluidConsonantsKey.isHidden = false
            trueScrollView.isHidden = false
            trueConsonantsKey.isHidden = false
            flipScrollView.isHidden = false
            flipConsonantsKey.isHidden = false
            silentScrollView.isHidden = false
            silentKey.isHidden = false
            wildScrollView.isHidden = false
            wildcardKey.isHidden = false
        }
            
        else {
            
            keyTypeLabel.text = "Macro View"
            
            fullKeyView.isHidden = false
            
            vowelScrollView.isHidden = true
            vowelKey.isHidden = true
            fluidScrollView.isHidden = true
            fluidConsonantsKey.isHidden = true
            trueScrollView.isHidden = true
            trueConsonantsKey.isHidden = true
            flipScrollView.isHidden = true
            flipConsonantsKey.isHidden = true
            silentScrollView.isHidden = true
            silentKey.isHidden = true
            wildScrollView.isHidden = true
            wildcardKey.isHidden = true
            
        }
    }
}
