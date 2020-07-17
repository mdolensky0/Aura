//
//  ViewController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var isSignedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()

    }
    
    func setupTabBar() {
        
        setupViewControllers()
        setupTabBarCustomizations()
        
    }

    func setupViewControllers() {
        
        let homeController = HomeController()
        let searchController = SearchController()
        let keyController = KeyController()
        let loginController = LoginController()
        let flashCardController = FlashCardController()
        let lessonsController = LessonsController()
        
        homeController.tabBarItem = UITabBarItem(title: "Home",
                                                 image: UIImage(named: "Home1"),
                                                 selectedImage: UIImage(contentsOfFile: "Home1"))
        
        searchController.tabBarItem = UITabBarItem(title: "Search",
                                                   image: UIImage(named: "Search1"),
                                                   selectedImage: UIImage(contentsOfFile: "Search1"))
     
        keyController.tabBarItem = UITabBarItem(title: "Key",
                                                image: UIImage(named: "Key1"),
                                                selectedImage: UIImage(contentsOfFile: "Key1"))
        
        loginController.tabBarItem = UITabBarItem(title: "Flashcards",
                                                  image: UIImage(named: "Flashcard1"),
                                                  selectedImage: UIImage(contentsOfFile: "Flashcard1"))
    
        flashCardController.tabBarItem = UITabBarItem(title: "Flashcards",
                                                      image: UIImage(named: "Flashcard1"),
                                                      selectedImage: UIImage(contentsOfFile: "Flashcard1"))
        
        lessonsController.tabBarItem = UITabBarItem(title: "Lessons",
                                                    image: UIImage(named: "Lessons1"),
                                                    selectedImage: UIImage(contentsOfFile: "Lessons1"))
        
        if isSignedIn {
            
            viewControllers = [homeController, searchController, keyController, flashCardController, lessonsController].map
                { UINavigationController(rootViewController: $0) }
        }
        
        else {
            
            viewControllers = [homeController, searchController, keyController, loginController, lessonsController].map
                           { UINavigationController(rootViewController: $0) }
        }
        
    }
    
    func setupTabBarCustomizations() {

        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.tintColor = K.Colors.purple
        tabBar.unselectedItemTintColor = K.Colors.darkGrey
        tabBar.itemPositioning = .centered
    }

}

