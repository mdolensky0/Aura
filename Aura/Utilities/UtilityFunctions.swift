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

class Utilities {
    
    static let shared = Utilities()
    
//MARK: - Sound Variables and Functions
    
    var soundItOutPlayer: AVAudioPlayer?
    var player : AVPlayer?

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

    func playAudioFile(urlString: String, loop: Int) {
        
        var count = 0
        
        guard let url = URL.init(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)) else { return }
        
        let playerItem = AVPlayerItem.init(url: url)
        
        player = AVPlayer.init(playerItem: playerItem)
        player?.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem,
                                               queue: .main)
        { [weak self] _ in
            
            if count < (loop - 1) {
                
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
                count += 1
                
            }
        }
    }
    
    //MARK: - Email and Password Validation
    
    func isPasswordValid(_ password : String) -> Bool{
        
        // 1 - Password length at least 8.
        // 2 - One Alphabet in Password.
        // 3 - One Special Character in Password
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid(_ enteredEmail:String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
    
//MARK: - Log In Properties/Methods
    
    var isUserSignedIn: Bool = false
    var tabController: TabBarController?
    
    func signUserOut(alertIn vc: UIViewController) {
        
        // Logout Alert
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        
        // Alert Actions
        let actionOk = UIAlertAction(title: "OK", style: .default) { (action) in
            return
        }
        
        let actionNo = UIAlertAction(title: "No", style: .cancel) { (action) in
            return
        }
        
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            // Sign Out
            do {
                
                try Auth.auth().signOut()
                
                let signedOutAlert = UIAlertController(title: "Success", message: "Successfully signed out", preferredStyle: .alert)
                
                signedOutAlert.addAction(actionOk)
                vc.present(signedOutAlert, animated: true, completion: nil)
                
                self.isUserSignedIn = false
                self.tabController?.isSignedIn = false
                
                self.tabController?.viewControllers = [self.tabController!.homeController,
                                                       self.tabController!.searchController,
                                                       self.tabController!.keyController,
                                                       self.tabController!.loginController,
                                                       self.tabController!.lessonsController]
                
            }
            
            catch let signOutError as NSError {
                
                let errorAlert = UIAlertController(title: "Error Signing Out", message: signOutError.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(actionOk)
                vc.present(errorAlert, animated: true, completion: nil)
                
            }
            
        }
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        vc.present(alert, animated: true, completion: nil)
        
    }
}
