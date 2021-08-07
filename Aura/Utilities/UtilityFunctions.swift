//
//  UtilityFunctions.swift
//  Aura
//
//  Created by Max Dolensky on 8/3/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

protocol FirebaseUpdaterDelegate {
    
    func updateMyDecksDisplay()
    func updatePopularDecksDisplay()
    func updateLessonsDisplay()
    func updateSecretsThumbnail()
    
}

extension FirebaseUpdaterDelegate {
    func updateMyDecksDisplay() { return }
    func updatePopularDecksDisplay() { return }
    func updateLessonsDisplay() { return }
    func updateSecretsThumbnail() { return }
}

protocol AddSearchHistoryDelegate {
    
    func updateSearchHistory()
    
}

class Utilities {
    
    static let shared = Utilities()
    
    var homeDelegate: FirebaseUpdaterDelegate?
    var decksDelegate: FirebaseUpdaterDelegate?
    var resultsDelegate: FirebaseUpdaterDelegate?
    var searchHistoryDelegate: AddSearchHistoryDelegate?
    var lessonsTabDelegate: FirebaseUpdaterDelegate?
    var settingsLauncher = SettingsLauncher()
    var popUpDelegate: FirebaseUpdaterDelegate?
    var learnMoreDelegates = [FirebaseUpdaterDelegate]()
    
    var user: User? {
        
        didSet {
            self.decksDelegate?.updateMyDecksDisplay()
            self.searchHistoryDelegate?.updateSearchHistory()
            self.homeDelegate?.updateMyDecksDisplay()
            self.resultsDelegate?.updateMyDecksDisplay()
            for delegate in learnMoreDelegates {
                delegate.updateMyDecksDisplay()
            }
            updateFunnelForSignIn()
        }
        
    }
    
    var superUser: User? {
        
        didSet {
            self.homeDelegate?.updatePopularDecksDisplay()
            self.decksDelegate?.updatePopularDecksDisplay()
        }
        
    }
    
    var lessons: [VideoGroup]? {
        didSet {
            self.homeDelegate?.updateLessonsDisplay()
            self.homeDelegate?.updateSecretsThumbnail()
            self.lessonsTabDelegate?.updateLessonsDisplay()
            self.resultsDelegate?.updateSecretsThumbnail()
            self.popUpDelegate?.updateSecretsThumbnail()
            for delegate in learnMoreDelegates {
                delegate.updateSecretsThumbnail()
            }
            
        }
    }
    
    var creatorCodes = Set<String>()
    
    //MARK: - Sound Variables and Functions
    var soundItOutPlayer: AVAudioPlayer?
    var player : AVPlayer?

//    func playAudioFile(urlString: String, loop: Int = 0, sender: UIButton) {
//        
//    }
    
    func updateFunnelForSignIn() {
        guard let funnelProgress = AdManager.shared.funnelProgress else {
            return
        }
        
        if funnelProgress == .completedVideo1Bought && user == nil {
            AdManager.shared.funnelProgress = .completedVideo1NoBuy
            return
        }
        
        if user != nil && user!.purchases[K.productNames.ehdMasterCourse] == true {
            AdManager.shared.funnelProgress = .completedVideo1Bought
            return
        }
        
        // For testing I can change a purchase back to false
//        if user != nil && user!.purchases[K.productNames.ehdMasterCourse] == false {
//            AdManager.shared.funnelProgress = .completedVideo2NoBuy
//            return
//        }
        
    }
    
    func playSound(_ soundFileName: String, volume: Float = 1) {
        guard let url = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            soundItOutPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = soundItOutPlayer else { return }
            player.volume = volume
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Email and Password Validation
    
    func isPasswordValid(_ password : String) -> Bool{
        
        // 1 - Password length at least 8.
        // 2 - One Alphabet in Password.
        // 3 - One Special Character in Password
        // NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        // Password must contain at least 8 characters
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^.{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid(_ enteredEmail:String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
    
    //MARK: - Log In Properties/Methods
    var isUserSignedIn: Bool = false {
        
        didSet {
            
            self.settingsLauncher.signInLabel.text = isUserSignedIn ? NSLocalizedString("Sign Out", comment: "Sign out(Log out) of your user account") : NSLocalizedString("Sign Up / Log In", comment: "Sign up or login to create a new user account")
            
        }
        
    }
    var tabController: TabBarController?
    
    func signUserOut(alertIn vc: UIViewController) {
        
        if let user = Utilities.shared.user {
            FirebaseManager.shared.updateUser(user: user)
        }
        
        // Logout Alert
        let alert = UIAlertController(title: NSLocalizedString("Logout", comment: "Log out of your user account"), message: NSLocalizedString("Are you sure you want to logout", comment: "Checking to make sure they actually want to log out before we log them out of their account"), preferredStyle: .alert)
        
        // Alert Actions
        let actionOk = UIAlertAction(title: NSLocalizedString("OK", comment: "ok, I acknowledge the action (for example successfully signing out) that just happened. When I press ok, the alert will go away and I can continue doing what I am doing in the app"), style: .default) { (action) in
            return
        }
        
        let actionNo = UIAlertAction(title: NSLocalizedString("No", comment: "No I don't want to perform this action (for example sign out)"), style: .cancel) { (action) in
            return
        }
        
        let actionYes = UIAlertAction(title: NSLocalizedString("Yes", comment: "Yes I do want to perform this action (for example sign out)"), style: .default) { (action) in
            
            // Sign Out
            do {
                
                try Auth.auth().signOut()
                
                self.isUserSignedIn = false
                self.user = nil
                
                let window = UIApplication.shared.keyWindow
                window?.rootViewController = UINavigationController(rootViewController: LoginController()) 
            }
            
            catch let signOutError as NSError {
                
                let errorAlert = UIAlertController(title: NSLocalizedString("Error Signing Out", comment: "Something went wrong and we were unable to sign you out"), message: signOutError.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(actionOk)
                vc.present(errorAlert, animated: true, completion: nil)
                
            }
            
        }
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        vc.present(alert, animated: true, completion: nil)
        
    }

    //MARK: - Add New Deck Function
    func getUniqueDeckName(from input: String, given myDecks: [DeckModel]) -> String {
        
        var nameSet = Set<String>()
        
        for deck in myDecks {
            
            nameSet.insert(deck.name)
            
        }
        
        if !nameSet.contains(input) {
            
            return input
            
        }
        
        var count = 1
        
        while true {
            
            let text = "\(input) \(count)"
            
            if !nameSet.contains(text) {
                
                return text
                
            }
            
            count += 1
            
        }
        
    }
}
