//
//  AppDelegate.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var hasAlreadyLaunched :Bool!
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure Firebase
        FirebaseApp.configure()

        _ = Firestore.firestore()
        _ = Storage.storage()
        
        // print(db, "\n")
        // print(storage, "\n")
        // print(Realm.Configuration.defaultConfiguration.fileURL, "\n")
        
        // Initialize New Realm
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        // Retrieve value from local store, if value doesn't exist then false is returned
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        
        // Check first launched
        if (hasAlreadyLaunched)
        {
            print("exists")
            hasAlreadyLaunched = true
            
        }else{
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
            
            RealmPopulater.populateRealm()
            RealmPopulater.addWildcardsToRealm()
            print("1st time")
        }
        
        // Setup audio to prevent first time  lag
        Utilities.shared.playSound("empty", volume: 0)
        
        // Do interface stuff for ios 12 version
        if #available(iOS 13.0, *) {
            // Do only pure app launch stuff, not interface stuff
        }
        
        else {
            
            window = UIWindow()
            window?.rootViewController = TabBarController()
            window?.makeKeyAndVisible()
                        
        }
                
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

