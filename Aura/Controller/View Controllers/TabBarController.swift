//
//  ViewController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    var isSignedIn = false
    
    var homeController: UINavigationController = {
        
        let vc = HomeController()
        
        vc.tabBarItem = UITabBarItem(title: "Home",
                                     image: UIImage(named: "Home1"),
                                     selectedImage: UIImage(contentsOfFile: "Home1"))
        
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.barStyle = .black
        
        return nc
        
    }()
    
    let searchController: UINavigationController = {
        
        let vc = SearchController()
        
        vc.tabBarItem = UITabBarItem(title: "Search",
                                     image: UIImage(named: "Search1"),
                                     selectedImage: UIImage(contentsOfFile: "Search1"))
        
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.barStyle = .black
        
        return nc
        
    }()
    
    let keyController: UINavigationController = {
        
        let vc = KeyController()
        
        vc.tabBarItem = UITabBarItem(title: "Key",
                                     image: UIImage(named: "Key1"),
                                     selectedImage: UIImage(contentsOfFile: "Key1"))
       
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.barStyle = .black
        
        return nc
    }()
    
    let loginController: UINavigationController = {
        
        let vc = LoginController()
        
        vc.tabBarItem = UITabBarItem(title: "Flashcards",
                                     image: UIImage(named: "Flashcard1"),
                                     selectedImage: UIImage(contentsOfFile: "Flashcard1"))
       
        return UINavigationController(rootViewController: vc)
        
    }()
    
    let flashCardController: UINavigationController = {
        
        let vc = FlashCardController()
        
        vc.tabBarItem = UITabBarItem(title: "Flashcards",
                                     image: UIImage(named: "Flashcard1"),
                                     selectedImage: UIImage(contentsOfFile: "Flashcard1"))
        
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.barStyle = .black
        
        return nc
        
    }()
    
    let lessonsController: UINavigationController = {
        
        let vc = LessonsController()
        
        vc.tabBarItem = UITabBarItem(title: "Lessons",
                                     image: UIImage(named: "Lessons1"),
                                     selectedImage: UIImage(contentsOfFile: "Lessons1"))
       
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.barStyle = .black
        
        return nc
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.shared.tabController = self
        setupTabBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupTabBar() {
        
        if Auth.auth().currentUser != nil {
            
            DispatchQueue.main.async {
                self.isSignedIn = true
                FirebaseManager.shared.loadUser()
                if let _ = Auth.auth().currentUser?.uid {
                    Utilities.shared.isUserSignedIn = true
                }
                self.setupViewControllers()
                self.setupTabBarCustomizations()
            }
            
        }
                    
        else {
            setupViewControllers()
            setupTabBarCustomizations()
        }
    }

    func setupViewControllers() {
        
        if isSignedIn {
            
            self.viewControllers = [homeController, searchController, keyController, flashCardController, lessonsController]
        }
        
        else {

            self.viewControllers = [homeController, searchController, keyController, loginController, lessonsController]
        }
        
    }
    
    func userSignedIn() {
        
        self.isSignedIn = true
        self.viewControllers = [homeController, searchController, keyController, flashCardController, lessonsController]
        
    }
    
    func setupTabBarCustomizations() {

        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.tintColor = K.DesignColors.primary
        tabBar.unselectedItemTintColor = K.Colors.darkGrey
        tabBar.itemPositioning = .centered
        
    }

}

