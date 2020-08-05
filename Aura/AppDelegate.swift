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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()

        let db = Firestore.firestore()
        print(db, "\n")
        print(Realm.Configuration.defaultConfiguration.fileURL, "\n")
        
        
        do {
            let realm = try Realm()
        } catch {
            print("Error initialising new real, \(error)")
        }
        
        //retrieve value from local store, if value doesn't exist then false is returned
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        
        //check first launched
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
        
        // setup audio to prevent first time  lag
        Utilities.shared.playSound("empty", volume: 0)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

