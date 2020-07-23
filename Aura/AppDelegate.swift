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
        
        // Uncomment Below to Update Realm Database
        //Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        //RealmPopulater.populateRealm()
        //RealmPopulater.addWildcardsToRealm()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

