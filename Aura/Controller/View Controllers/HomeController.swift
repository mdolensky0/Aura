//
//  HomeViewController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        label.backgroundColor = .clear
        label.font = UIFont(name: K.Fonts.avenirBlack, size: 17)
        label.text = "Aura"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var searchView: UIView = {
        
        let container = UIView()
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "TheSearch"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.roundCorners(cornerRadius: 10)
        button.addTarget(self, action: #selector(goToSearch), for: .touchUpInside)
        
        container.addSubview(button)
        button.anchor(top: container.topAnchor,
                      bottom: container.bottomAnchor,
                      leading: container.leadingAnchor,
                      trailing: container.trailingAnchor,
                      height: nil,
                      width: nil)
        
        return container
        
    }()
    
    var keyView: UIView = {
        
        let container = UIView()
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "TheKey"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.roundCorners(cornerRadius: 10)
        button.addTarget(self, action: #selector(goToKey), for: .touchUpInside)
        
        container.addSubview(button)
        button.anchor(top: container.topAnchor,
                      bottom: container.bottomAnchor,
                      leading: container.leadingAnchor,
                      trailing: container.trailingAnchor,
                      height: nil,
                      width: nil)
        
        return container
        
    }()
    
    var flashcardsView: UIView = {
        
        let container = UIView()
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "TheFlashcards"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.roundCorners(cornerRadius: 10)
        button.addTarget(self, action: #selector(goToFlashcards), for: .touchUpInside)
        
        container.addSubview(button)
        button.anchor(top: container.topAnchor,
                      bottom: container.bottomAnchor,
                      leading: container.leadingAnchor,
                      trailing: container.trailingAnchor,
                      height: nil,
                      width: nil)
        
        return container
        
    }()
    
    var lessonsView: UIView = {
        
        let container = UIView()
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "TheLessons"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.roundCorners(cornerRadius: 10)
        button.addTarget(self, action: #selector(goToLessons), for: .touchUpInside)
        
        container.addSubview(button)
        button.anchor(top: container.topAnchor,
                      bottom: container.bottomAnchor,
                      leading: container.leadingAnchor,
                      trailing: container.trailingAnchor,
                      height: nil,
                      width: nil)
        
        return container
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        
        searchView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
        keyView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
        flashcardsView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
        lessonsView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
    }
    
    func setup() {
        
        view.backgroundColor = K.DesignColors.background
        
        // Add Center Title
        self.navigationItem.titleView = titleLabel
        
        // Add user button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain,
                                                                 target: self, action: #selector(profileButtonTapped))
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.DesignColors.primary
        
        view.addSubview(searchView)
        view.addSubview(keyView)
        view.addSubview(flashcardsView)
        view.addSubview(lessonsView)
        
        searchView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          bottom: nil,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          height: 157,
                          width: nil,
                          padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        
        keyView.anchor(top: searchView.bottomAnchor,
                       bottom: nil,
                       leading: searchView.leadingAnchor,
                       trailing: nil,
                       height: 157,
                       width: nil,
                       padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        keyView.widthAnchor.constraint(equalTo: searchView.widthAnchor, multiplier: 0.5, constant: -10).isActive = true
        
        flashcardsView.anchor(top: searchView.bottomAnchor,
                       bottom: nil,
                       leading: nil,
                       trailing: searchView.trailingAnchor,
                       height: 157,
                       width: nil,
                       padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        flashcardsView.widthAnchor.constraint(equalTo: searchView.widthAnchor, multiplier: 0.5, constant: -10).isActive = true
        
        lessonsView.anchor(top: keyView.bottomAnchor,
                           bottom: nil,
                           leading: searchView.leadingAnchor,
                           trailing: searchView.trailingAnchor,
                           height: 157,
                           width: nil,
                           padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    @objc func goToSearch() {
        
        self.tabBarController?.selectedIndex = 1
        
    }
    
    @objc func goToKey() {
        
        self.tabBarController?.selectedIndex = 2
        
    }
    
    @objc func goToFlashcards() {
        
        self.tabBarController?.selectedIndex = 3
        
    }
    
    @objc func goToLessons() {
        
        self.tabBarController?.selectedIndex = 4
        
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
}
