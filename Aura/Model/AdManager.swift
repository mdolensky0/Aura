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
    case completedVideo1NoBuy = "completedVideo1NoBuy"
    case completedVideo1Bought = "completedVideo1Bought"
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
    
    var currentVideoPosition: VideoPosition {
        get {
            
            guard let positionData = UserDefaults.standard.data(forKey: "currentVideoPosition") else {
                return VideoPosition(baseID: K.FBConstants.baseCourseIDs[0], section: 0, row: 0)
            }
            return VideoPosition(data: positionData)
            
        }
        
        set(newValue) {
    
            if let data = newValue.encode() {
                UserDefaults.standard.set(data, forKey: "currentVideoPosition")
                homeDelegate?.updateSecretsThumbnail()
                searchDelegate?.updateSecretsThumbnail()
                resultDelegate?.updateSecretsThumbnail()
                for delegate in learnMoreDelegates {
                    delegate.updateSecretsThumbnail()
                }
            }
        }
    }
    
    var introVideoTimeLeftAt: Double {
        get {
            return UserDefaults.standard.double(forKey: "introVideoTimeLeftAt")
        }
        
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "introVideoTimeLeftAt")
        }
    }
    
    let videoBuyPopUp = BuyButtonPopUpView(frame: .zero, isVideoPopUp: true)
    let vcBuyPopUp = BuyButtonPopUpView(frame: .zero, isVideoPopUp: false)
    
    var isBuyButtonShowing = false
    
    func getFunnelThumbnailURLForCurrentUserState() -> String {
        
        guard let lessons = Utilities.shared.lessons else {
            return ""
        }
        
        guard let intro = lessons.first(where: {$0.baseID == K.FBConstants.baseCourseIDs[0]}) else {
            return ""
        }
        
        let position = currentVideoPosition
        
        switch funnelProgress {
        case .none, .hasNotSeenVideo1, .seenPartOfVideo1:
            return intro.sections[0].videos[0].thumbnailURL
        case .completedVideo1NoBuy, .completedVideo1Bought:
            AnalyticsManager.shared.logStartedVideo(position: position)
            guard let currCourse = lessons.first(where: {$0.baseID == position.baseID}) else {
                return ""
            }
            return currCourse.sections[position.section].videos[position.row].thumbnailURL
        }
    }
    
    func shouldVideoBeLocked() -> Bool {
        
        guard let funnelProgress = funnelProgress else {
            return false
        }
        
        if funnelProgress != .completedVideo1Bought
            && currentVideoPosition.baseID == K.FBConstants.baseCourseIDs[1]
            &&  currentVideoPosition.section > 2 {
            return true
        } else {
            return false
        }
        
    }
    
    func lessonPageToScrollTo() -> Int {
        switch funnelProgress {
        case .hasNotSeenVideo1, .seenPartOfVideo1:
            return 1
        case .completedVideo1NoBuy, .completedVideo1Bought:
            return 0
        default:
            return 0
        }
    }
    
    func getFunnelLabelTitleForCurrentUserState() -> String {
        
        switch funnelProgress {
        case .hasNotSeenVideo1:
            return NSLocalizedString("Where to Start", comment: "Start of using this app by watching this video")
        case .seenPartOfVideo1:
            return NSLocalizedString("Continue Watching", comment: "Finish watching this video that you already started")
        case .completedVideo1NoBuy where currentVideoPosition.section <= 2:
            return NSLocalizedString("Sample the English HD Master Course", comment: "Try out watching a video from the course for free")
        case .completedVideo1NoBuy:
            return NSLocalizedString("Get the English HD Master Course Now!", comment: "Purchase the course now")
        case .completedVideo1Bought:
            return NSLocalizedString("Continue Learning", comment: "Continue watching videos where you left off in the course to keep learning")
        case .none:
            return NSLocalizedString("Where to Start", comment: "Start of using this app by watching this video")
        }
    }
    
    func getVideoURLForCurrentUserState() -> String {
        guard let lessons = Utilities.shared.lessons else {
            return ""
        }
        
        guard let intro = lessons.first(where: {$0.baseID == K.FBConstants.baseCourseIDs[0]}) else {
            return ""
        }
        
        let position = currentVideoPosition
        
        switch funnelProgress {
        case .none, .hasNotSeenVideo1, .seenPartOfVideo1:
            return intro.sections[0].videos[0].videoURL
        case .completedVideo1NoBuy, .completedVideo1Bought:
            AnalyticsManager.shared.logStartedVideo(position: position)
            guard let currCourse = lessons.first(where: {$0.baseID == position.baseID}) else {
                return ""
            }
            return currCourse.sections[position.section].videos[position.row].videoURL
        }
    }
    
    func getPositionForCurrentUserState() -> VideoPosition {
        switch funnelProgress {
        case .none, .hasNotSeenVideo1, .seenPartOfVideo1:
            return VideoPosition(baseID: RCManager.shared.value(forKey: K.RCConstants.introBaseID), section: 0, row: 0)
        case .completedVideo1NoBuy, .completedVideo1Bought:
            return currentVideoPosition
        }
    }
    
    func getSecretsVideoPopUpManagerForCurrentFunnelState() -> SecretsVideoPopUpManager {
        switch funnelProgress {
        case .hasNotSeenVideo1:
            return SecretsVideoPopUpManager(title: NSLocalizedString("Welcome to Aura!", comment: ""),
                                            info: NSLocalizedString("Get started with this tutorial video. Learn how to use this app and discover the 3 Secrets of English HD", comment: ""),
                                            thumbnailURL: getFunnelThumbnailURLForCurrentUserState(),
                                            buttonText: NSLocalizedString("Watch Tutorial", comment: "Click this button to watch the tutorial video"))
        case .seenPartOfVideo1:
            return SecretsVideoPopUpManager(title: NSLocalizedString("Finish the tutorial!", comment: "Finish watching the tutorial video"),
                                            info: NSLocalizedString("We recommend finishing this video to help you better understand the features in this app and how to use them", comment: ""),
                                            thumbnailURL: getFunnelThumbnailURLForCurrentUserState(),
                                            buttonText: NSLocalizedString("Finish Tutorial", comment: "Click this button to finish watching the tutorial video"))
        default:
            return SecretsVideoPopUpManager(title: NSLocalizedString("Welcome to Aura!", comment: ""),
                                            info: NSLocalizedString("Get started with this tutorial video. Learn how to use this app and discover the 3 Secrets of English HD", comment: ""),
                                            thumbnailURL: getFunnelThumbnailURLForCurrentUserState(),
                                            buttonText: NSLocalizedString("Watch Tutorial", comment: "Click this button to watch the tutorial video"))
        }
    }
    
    func showAdPopUP(parentVC: UIViewController) {
        
        guard let funnelProgress = funnelProgress else { return }
        if funnelProgress == .completedVideo1Bought || funnelProgress == .completedVideo1NoBuy {
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
        if funnelProgress == .completedVideo1Bought || funnelProgress == .completedVideo1NoBuy { return }
        
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
            if funnelProgress == .hasNotSeenVideo1 || funnelProgress == .seenPartOfVideo1 {
                UserDefaults.standard.setValue(count + 1, forKey: "searchCount")
                showAdPopUP(parentVC: parentVC)
            }
        }
    }
    
    func showBuyButton(inVideo: Bool = true, videoVC: PUAVPlayerViewController?, parentVC: UIViewController?) {
        
        AnalyticsManager.shared.logBuyButtonSeen()
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
