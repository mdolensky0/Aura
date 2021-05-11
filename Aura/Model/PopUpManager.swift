//
//  PopUpManager.swift
//  Aura
//
//  Created by Maxwell Dolensky on 10/19/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

// MARK: - Base Class
class PopUpManager: NSObject {
    
    var blackView: UIView = {
        
        let v = UIView()
        v.backgroundColor = UIColor(white: 0 , alpha: 0.5)
        return v
        
    }()
    
    override init() {
        super.init()
    }
    
    func showPopUpFromBottom() {}
        
    fileprivate func showPopUpFromBottom(v: UIView) {
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(blackView)
            window.addSubview(v)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            v.translatesAutoresizingMaskIntoConstraints = false
            v.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            v.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            
            v.transform = CGAffineTransform(translationX: 0, y: window.frame.height)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                v.transform = .identity
            }, completion: nil)
        }
    }
    
    func showPopUpFadingIn() {}
    
    fileprivate func showPopUpFadingIn(v: UIView) {
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(blackView)
            window.addSubview(v)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            v.alpha = 0
            
            v.translatesAutoresizingMaskIntoConstraints = false
            v.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            v.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            
            UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                v.alpha = 1
            }, completion: nil)
        }
    }
}

protocol TestManagerDelegate {
    func finishTest(willRestart: Bool)
}

// MARK: - Test Result Pop Up Class
class TestResultPopUpManager: PopUpManager, TestResultPopUpDelegate {
    
    var popUpView = TestResultPopUpView()
    var delegate: TestManagerDelegate?
    
    convenience init(popUpView: TestResultPopUpView) {
        self.init()
        self.popUpView = popUpView
        self.popUpView.delegate = self
    }
    
    override func showPopUpFromBottom() {
        showPopUpFromBottom(v: popUpView)
    }
    
    func dismiss(completion: @escaping() -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.popUpView.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height)
        }) { (_) in
            self.blackView.removeFromSuperview()
            self.popUpView.removeFromSuperview()
            completion()
        }
    }
    
    func done() {
        dismiss { self.delegate?.finishTest(willRestart: false) }
    }
    
    func restart() {
        dismiss { self.delegate?.finishTest(willRestart: true) }
    }
    
}

// MARK: - Study Result Pop Up Class
class StudyResultPopUpManager: PopUpManager, TestResultPopUpDelegate {
    
    var popUpView = StudyResultPopUpView()
    var delegate: TestManagerDelegate?
    
    convenience init(popUpView: StudyResultPopUpView) {
        self.init()
        self.popUpView = popUpView
        self.popUpView.delegate = self
    }
    
    override func showPopUpFromBottom() {
        showPopUpFromBottom(v: popUpView)
    }
    
    func dismiss(completion: @escaping() -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.popUpView.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height)
        }) { (_) in
            self.blackView.removeFromSuperview()
            self.popUpView.removeFromSuperview()
            completion()
        }
    }
    
    func done() {
        dismiss { self.delegate?.finishTest(willRestart: false) }
    }
    
    func restart() {
        dismiss { self.delegate?.finishTest(willRestart: true) }
    }
    
}

// MARK: - Swipe Tutorial Pop Up Class
class SwipeTutorialPopUpManager: PopUpManager, SwipeTutorialDelegate {
    
    lazy var popUpView: SwipeTutorialView = {
        let v = SwipeTutorialView()
        v.delegate = self
        return v
    }()
    
    override func showPopUpFadingIn() {
        showPopUpFadingIn(v: popUpView)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.popUpView.alpha = 0
        }) { (_) in
            self.blackView.removeFromSuperview()
            self.popUpView.removeFromSuperview()
        }
    }
}

// MARK: - Secrets Video Pop Up Manager
class SecretsVideoPopUpManager: PopUpManager, SecretsTutorialDelegate {
    
    var popUpView = SecretsPopUpView()
    var parentView: UIViewController?
    
    convenience init(title: String, info: String, thumbnailURL: String, buttonText: String) {
        self.init()
        popUpView = SecretsPopUpView(
            frame: .zero,
            titleText: title,
            infoText: info,
            thumbnailURL: thumbnailURL,
            buttonText: buttonText
        )
        popUpView.delegate = self
    }
    
    override func showPopUpFadingIn() {
        showPopUpFadingIn(v: popUpView)
        print("\nPopping Up\n")
    }
    
    func dismiss(didSkip: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.popUpView.alpha = 0
        }) { (_) in
            self.blackView.removeFromSuperview()
            self.popUpView.removeFromSuperview()
            
            guard let funnelProgress = AdManager.shared.funnelProgress else { return }
            
            if didSkip  {
                if let _ = self.parentView as? HomeController {
                    if funnelProgress == .hasNotSeenVideo1 || funnelProgress == .seenPartOfVideo1 {
                        let vc = TutorialController()
                        vc.modalPresentationStyle = .fullScreen
                        self.parentView?.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func playVideo() {
        
        dismiss(didSkip: false)
        
        let av = PUAVPlayerViewController()
        av.parentView = parentView
        let urlString = AdManager.shared.getVideoURLForCurrentUserState()
        
        let position = AdManager.shared.getPositionForCurrentUserState()
        
        guard let videoGroups = Utilities.shared.lessons else {
            return
        }
        
        guard let lesson = videoGroups.first(where: {$0.baseID == AdManager.shared.currentVideoPosition.baseID}) else {
            return
        }
                
        if let url = URL(string: urlString) {
            
            let player = AVPlayer(url: url)
            av.player = player
            av.player?.automaticallyWaitsToMinimizeStalling = true
            
            // Add Observer
            let interval = CMTime(value: 1, timescale: 2)
            av.timeObserver = av.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let min = Int(seconds / 60)
                let secs = Int(seconds) % 60
                
                switch AdManager.shared.funnelProgress {
                
                case .hasNotSeenVideo1 where lesson.baseID == K.FBConstants.baseCourseIDs[0]:
                    AdManager.shared.funnelProgress = .seenPartOfVideo1
                    AnalyticsManager.shared.logFunnelChange(funnelProgress: .seenPartOfVideo1)
                
                case .seenPartOfVideo1 where lesson.baseID == K.FBConstants.baseCourseIDs[0]:
                    if min >= K.FunnelConstants.minuteToShowBuyBtn && secs >= K.FunnelConstants.secondToShowBuyBtn {
                        AdManager.shared.funnelProgress = .completedVideo1NoBuy
                        AnalyticsManager.shared.logFunnelChange(funnelProgress: .completedVideo1NoBuy)
                        AdManager.shared.showBuyButton(videoVC: av, parentVC: nil)
                        AdManager.shared.isBuyButtonShowing = true
                        AdManager.shared.currentVideoPosition = VideoPosition(baseID: K.FBConstants.baseCourseIDs[1], section: 0, row: 0)
                    }
                
                case .completedVideo1NoBuy:
                    if secs >= K.FunnelConstants.secondToShowBuyIfIntroSeen && AdManager.shared.isBuyButtonShowing == false {
                        AdManager.shared.showBuyButton(videoVC: av, parentVC: nil)
                        AdManager.shared.isBuyButtonShowing = true
                    }
                    self.updateNextVideoIfNecessary(av, progressTime: seconds, currPosition: position, videoGroup: lesson)
                
                case .completedVideo1Bought:
                    self.updateNextVideoIfNecessary(av, progressTime: seconds, currPosition: position, videoGroup: lesson)

                default:
                    break
                }
            })
            parentView!.present(av, animated: true) {
                
                av.player!.play()
                if AdManager.shared.funnelProgress == .seenPartOfVideo1 && lesson.baseID == K.FBConstants.baseCourseIDs[0] {
                    av.player!.seek(to: CMTime(seconds: AdManager.shared.introVideoTimeLeftAt, preferredTimescale: 1))
                }
            }
        }
    }
    
    func updateNextVideoIfNecessary(_ av: PUAVPlayerViewController, progressTime: Double, currPosition: VideoPosition, videoGroup: VideoGroup) {
        if let duration = av.player?.currentItem?.duration {
            let durationSecs = CMTimeGetSeconds(duration)
            if durationSecs - progressTime <= Double(K.VideoConstants.secondsToMarkVideoFinished) {
            
                if currPosition.row < videoGroup.sections[currPosition.section].videos.count - 1 {
                    let newPosition = VideoPosition(baseID: currPosition.baseID, section: currPosition.section, row: currPosition.row + 1)
                    AdManager.shared.currentVideoPosition = newPosition
                    AnalyticsManager.shared.logFinishedVideo(position: newPosition)
                } else if currPosition.section < videoGroup.sections.count - 1 {
                    let newPosition = VideoPosition(baseID: currPosition.baseID, section: currPosition.section + 1, row: 0)
                    AdManager.shared.currentVideoPosition = newPosition
                    AnalyticsManager.shared.logFinishedVideo(position: newPosition)
                }
            }
        }
    }
}

// MARK: - Pop Up AV Player View Controller
class PUAVPlayerViewController: AVPlayerViewController {
    
    override func viewDidDisappear(_ animated: Bool) {
        handleVideoCloseForCurrentState()
        player?.pause()
        if let currentTime = player?.currentTime().seconds {
            AdManager.shared.introVideoTimeLeftAt = currentTime - 5 >= 0  ? currentTime - 5 : 0
        }
        player?.removeTimeObserver(timeObserver!)
        AdManager.shared.removeBuyButton()
    }
    
    var parentView: UIViewController?
    var timeObserver: Any?
    var isIntro: Bool = false
    
    func handleVideoCloseForCurrentState() {
        
        guard let funnelProgress = AdManager.shared.funnelProgress else { return }
    
        if let _ = parentView as? HomeController {
            if funnelProgress == .hasNotSeenVideo1 || funnelProgress == .seenPartOfVideo1 {
                let vc = TutorialController()
                vc.modalPresentationStyle = .fullScreen
                self.parentView?.present(vc, animated: true, completion: nil)
                return
            } else { return }
        }
    
        if let _ = parentView as? ResultsController {
            if funnelProgress == .completedVideo1Bought {
                parentView?.tabBarController?.selectedIndex = 4
            } else { return }
        }
        
        if let _ = parentView as? FlashCardController {
            if funnelProgress == .completedVideo1Bought {
                parentView?.tabBarController?.selectedIndex = 4
            } else { return }
        }
        
        if let _ = parentView as? DeckSelectingController {
            if funnelProgress == .completedVideo1Bought {
                parentView?.tabBarController?.selectedIndex = 4
            } else { return }
        }
        
        if let _ = parentView as? LessonsController {
            if funnelProgress == .completedVideo1Bought {
                parentView?.tabBarController?.selectedIndex = 4
            } else { return }
        }
    }
    
    func goToLogin() {
        
        let vc = UINavigationController(rootViewController: LoginController())
        let login = vc.viewControllers[0] as! LoginController
        login.isModal = true
        login.isForPurchase = true
        self.present(vc, animated: true, completion: nil)
        
    }

}
