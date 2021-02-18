//
//  AdManager.swift
//  Aura
//
//  Created by Maxwell Dolensky on 2/3/21.
//  Copyright © 2021 Max Dolensky. All rights reserved.
//

import UIKit

enum FunnelProgress: String {
    case hasNotSeenVideo1 = "hasNotSeenVideo1"
    case seenPartOfVideo1 = "seenPartOfVideo1"
    case completedVideo1 = "completedVideo1"
    case seenPartOfVideo2 = "seenPartOfVideo2"
    case completedVideo2NoBuy = "completedVideo2NoBuy"
    case completedVideo2Bought = "completedVideo2Bought"
}

protocol AdManagerDelegate {
    func updateSecretsThumbnail()
}

class AdManager: NSObject {
    
    static var shared = AdManager()
    
    var homeDelegate: AdManagerDelegate?
    var searchDelegate: AdManagerDelegate?
    var resultDelegate: AdManagerDelegate?
    var learnMoreDelegates = [FirebaseUpdaterDelegate]()
    var lessonDelegate: FirebaseUpdaterDelegate?
    
    var funnelProgress: FunnelProgress? {
        
        get {
            
            guard let progressString = UserDefaults.standard.object(forKey: "funnelProgress") as? String else {
                return nil
            }
            
            guard let funnelProgress = FunnelProgress(rawValue: progressString) else {
                return nil
            }
            
            return funnelProgress
        }
        
        set(newValue) {
            UserDefaults.standard.setValue(newValue?.rawValue, forKey: "funnelProgress")
            homeDelegate?.updateSecretsThumbnail()
            searchDelegate?.updateSecretsThumbnail()
            resultDelegate?.updateSecretsThumbnail()
            for delegate in learnMoreDelegates {
                delegate.updateSecretsThumbnail()
            }
            lessonDelegate?.updateLessonsDisplay()
            
        }
    }
    
    var currentLessonIndex: Int? {
        get {
            
            guard let idxObject = UserDefaults.standard.object(forKey: "currentLessonNum") else {
                return nil
            }
            
            guard let idx = idxObject as? Int else {
                return nil
            }
            
            return idx
            
        }
        
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "currentLessonNum")
            homeDelegate?.updateSecretsThumbnail()
            searchDelegate?.updateSecretsThumbnail()
            resultDelegate?.updateSecretsThumbnail()
            for delegate in learnMoreDelegates {
                delegate.updateSecretsThumbnail()
            }
        }
    }
    
    let videoBuyPopUp = BuyButtonPopUpView(frame: .zero, isVideoPopUp: true)
    let vcBuyPopUp = BuyButtonPopUpView(frame: .zero, isVideoPopUp: false)
    
    var isBuyButtonShowing = false
    
    func getFunnelThumbnailURLForCurrentUserState() -> String {
        
        guard let lessons = Utilities.shared.lessons else {
            return ""
        }
        
        if lessons.count < 2 {
            return ""
        }
        
        switch funnelProgress {
        case .hasNotSeenVideo1, .seenPartOfVideo1:
            // Return Video 1 Thumbnail
            return lessons[0].videos[0].videoThumbnailURL
        case .completedVideo1, .seenPartOfVideo2:
            // Return Video 2 Thumbnail
            return lessons[0].videos[1].videoThumbnailURL
        case .completedVideo2NoBuy:
            // Return Lessons Intro Thumbnail
            return fetchVideoThumbnailForLessonNum()
        case .completedVideo2Bought:
            // Return Lesson Video Thumbnail they left off at
            return fetchVideoThumbnailForLessonNum()
        case .none:
            // Return Video 1. User Default not set yet
            return lessons[0].videos[0].videoThumbnailURL
        }
        
    }
    
    func shouldVideoBeLocked() -> Bool {
        
        guard let idx = currentLessonIndex else {
            return true
        }
        
        if funnelProgress! == .completedVideo2NoBuy && idx > 0 {
            return true
        } else {
            return false
        }
        
    }
    
    func lessonPageToScrollTo() -> Int {
        switch funnelProgress {
        case .hasNotSeenVideo1, .seenPartOfVideo1, .completedVideo1, .seenPartOfVideo2:
            return 0
        case .completedVideo2NoBuy, .completedVideo2Bought:
            return 1
        default:
            return 0
        }
    }
    
    func getFunnelLabelTitleForCurrentUserState() -> String {
        
        switch funnelProgress {
        case .hasNotSeenVideo1:
            return "Where to Start"
        case .seenPartOfVideo1:
            return "Continue Watching"
        case .completedVideo1:
            return "Next Step"
        case .seenPartOfVideo2:
            return "Continue Watching"
        case .completedVideo2NoBuy where currentLessonIndex! <= 0:
            return "Sample the EHD Master Course"
        case .completedVideo2NoBuy where currentLessonIndex! > 0:
            return "Get the EHD Master Course Now!"
        case .completedVideo2Bought:
            return "Continue Learning"
        case .none:
            return "Where to Start"
        case .some(.completedVideo2NoBuy):
            return "Sample the EHD Master Course"
        }
        
    }
    
    func getVideoURLForCurrentUserState() -> String {
        switch funnelProgress {
        case .none, .hasNotSeenVideo1, .seenPartOfVideo1:
            // Video 1
            return "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Secrets_1_2.mp4?alt=media&token=7a1c0674-0023-4c0a-bee5-9416341ed787"
        case .completedVideo1, .seenPartOfVideo2:
            // Video 2
           return "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/Secrets_3.mp4?alt=media&token=d637f059-443e-47cb-a37a-c783c88654aa"
        case .completedVideo2NoBuy:
            return fetchVideoURLForLessonNum()
        case .completedVideo2Bought:
            return fetchVideoURLForLessonNum()
        }
    }
    
    func getSecretsVideoPopUpManagerForCurrentFunnelState() -> SecretsVideoPopUpManager {
        switch funnelProgress {
        case .hasNotSeenVideo1:
            return SecretsVideoPopUpManager(title: "Welcome to Aura!",
                                            info: "Get started with this tutorial video to learn all about this app",
                                            thumbnailURL: getFunnelThumbnailURLForCurrentUserState(),
                                            buttonText: "Watch Tutorial")
        case .seenPartOfVideo1:
            return SecretsVideoPopUpManager(title: "Finish the tutorial!",
                                            info: "We recommend finishing this video to help you better understand the features in this app and how to use them",
                                            thumbnailURL: getFunnelThumbnailURLForCurrentUserState(),
                                            buttonText: "Finish Tutorial")
        case .completedVideo1:
            return SecretsVideoPopUpManager(title: "Discover Secret 3!",
                                            info: "Learn about the free and amazing flashcard section where learning and practing is made easy.",
                                            thumbnailURL: getFunnelThumbnailURLForCurrentUserState(),
                                            buttonText: "Watch Video")
        default:
            return SecretsVideoPopUpManager(title: "Finish Learning about Flashcards",
                                            info: "We recommend finishing this video to help you better understand the features in this app and how to use them",
                                            thumbnailURL: getFunnelThumbnailURLForCurrentUserState(),
                                            buttonText: "Finish Video")
        }
    }
    
    func showAdPopUP(parentVC: UIViewController) {
        
        guard let funnelProgress = funnelProgress else { return }
        if funnelProgress == .completedVideo2Bought || funnelProgress == .completedVideo2NoBuy {
            return
        }
        
        let popUpManager = AdManager.shared.getSecretsVideoPopUpManagerForCurrentFunnelState()
        popUpManager.parentView = parentVC
        popUpManager.showPopUpFadingIn()
    }
    
    func updateSearchCount() {
        
        // If funnel Progress Nil, return
        guard let funnelProgress = AdManager.shared.funnelProgress else { return }
        
        // If they have not finished video 1, don't start counting for video 2 ad
        if funnelProgress == .hasNotSeenVideo1 || funnelProgress == .seenPartOfVideo1 { return }
        
        guard let searchCount = UserDefaults.standard.object(forKey: "searchCount") else {
            UserDefaults.standard.setValue(1, forKey: "searchCount")
            return
        }
        
        guard let count = searchCount as? Int else { return }
        
        if count > 7 {
            return
        } else if count < 7 {
            UserDefaults.standard.setValue(count + 1, forKey: "searchCount")
        }
    }
    
    func showPopUpAfterSearch(parentVC: UIViewController) {
        guard let searchCount = UserDefaults.standard.object(forKey: "searchCount") else {
            return
        }
        
        guard let count = searchCount as? Int else { return }
        
        if count == 7 {
            guard let funnelProgress = AdManager.shared.funnelProgress else { return }
            if funnelProgress == .completedVideo1 || funnelProgress == .seenPartOfVideo2 {
                UserDefaults.standard.setValue(count + 1, forKey: "searchCount")
                showAdPopUP(parentVC: parentVC)
            }
        }
    }
    
    func fetchVideoURLForLessonNum() -> String {
        if let idx = currentLessonIndex {
            
            if let lessons = Utilities.shared.lessons {
                
                if idx < lessons[1].videos.count {
                    return lessons[1].videos[idx].videoURL
                } else {
                    let idx = lessons[1].videos.count - 1
                    return lessons[1].videos[idx].videoURL
                }
                
            } else {
                return "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/IntroVideo.m4v?alt=media&token=ce50bace-989b-43e7-9551-7b5a9a0b8802"
            }
            
        } else {
            currentLessonIndex = 0
            return "https://firebasestorage.googleapis.com/v0/b/simply-english-10f6f.appspot.com/o/IntroVideo.m4v?alt=media&token=ce50bace-989b-43e7-9551-7b5a9a0b8802"
        }
    }
    
    func fetchVideoThumbnailForLessonNum() -> String {
        
        guard let lessons = Utilities.shared.lessons else {
            return ""
        }
        
        if lessons.count < 2 {
            return ""
        }
        
        guard let idx = currentLessonIndex else {
            currentLessonIndex = 0
            return lessons[1].videos[0].videoThumbnailURL
        }
        
        if idx >= lessons[1].videos.count {
            let lastIdx = lessons[1].videos.count - 1
            return lessons[1].videos[lastIdx].videoThumbnailURL
        }
        
        return lessons[1].videos[idx].videoThumbnailURL
    
    }
    
    func showBuyButton(inVideo: Bool = true, videoVC: PUAVPlayerViewController?, parentVC: UIViewController?) {
        
        let buyPopUp = inVideo ? videoBuyPopUp : vcBuyPopUp
        buyPopUp.videoVC = videoVC
        buyPopUp.parentVC = parentVC
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(buyPopUp)
            buyPopUp.translatesAutoresizingMaskIntoConstraints = false
            buyPopUp.anchor(top: nil,
                            bottom: window.bottomAnchor,
                            leading: window.safeAreaLayoutGuide.leadingAnchor,
                            trailing: window.safeAreaLayoutGuide.trailingAnchor,
                            height: nil,
                            width: nil,
                            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            
            if inVideo {
                buyPopUp.reset()
            }
            
            buyPopUp.transform = CGAffineTransform(translationX: 0, y: 150)
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                buyPopUp.transform = .identity
            }, completion: nil)
        }
    }
    
    func removeBuyButton() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            if self.videoBuyPopUp.superview != nil {
                self.videoBuyPopUp.transform = CGAffineTransform(translationX: 0, y: 300)
            } else {
                self.vcBuyPopUp.transform = CGAffineTransform(translationX: 0, y: 300)
            }
        } completion: { (_) in
            if self.videoBuyPopUp.superview != nil {
                self.videoBuyPopUp.removeFromSuperview()
                self.isBuyButtonShowing = false
            } else {
                self.vcBuyPopUp.removeFromSuperview()
            }
        }
    }
}
