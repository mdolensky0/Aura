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
            
            UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
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

// MARK: - Test Result Pop Up Class
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

class SecretsVideoPopUpManager: PopUpManager, SecretsTutorialDelegate {
    
    var popUpView = SecretsPopUpView()
    var parentView: UIViewController?
    
    convenience init(title: String, info: String, thumbnailURL: String, buttonText: String) {
        self.init()
        popUpView = SecretsPopUpView(frame: .zero,
                                     titleText: title,
                                     infoText: info,
                                     thumbnailURL: thumbnailURL,
                                     buttonText: buttonText)
        popUpView.delegate = self
    }
    
    override func showPopUpFadingIn() {
        showPopUpFadingIn(v: popUpView)
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
                
        if let url = URL(string: urlString) {
            
            let player = AVPlayer(url: url)
            av.player = player
            av.player?.automaticallyWaitsToMinimizeStalling = true
            
            // Add Observer
            let interval = CMTime(value: 1, timescale: 2)
            av.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                
                if Int(seconds / 60) >= 15 && Int(seconds) % 60 >= 15  {
                    switch AdManager.shared.funnelProgress {
                    case .completedVideo1, .seenPartOfVideo2:
                        AdManager.shared.funnelProgress = .completedVideo2NoBuy
                    default:
                        break
                    }
                } else if Int(seconds / 60)  >= 9 {
                    switch AdManager.shared.funnelProgress {
                    case .hasNotSeenVideo1, .seenPartOfVideo1:
                        AdManager.shared.funnelProgress = .completedVideo1
                    default:
                        break
                    }
                } else {
                    switch AdManager.shared.funnelProgress {
                    case .hasNotSeenVideo1:
                        AdManager.shared.funnelProgress = .seenPartOfVideo1
                    case .completedVideo1:
                        AdManager.shared.funnelProgress = .seenPartOfVideo2
                    default:
                        break
                    }
                }
            })
            
            parentView?.present(av, animated: true) {
                
                av.player!.play()
            }
        }
    }
        
}

class PUAVPlayerViewController: AVPlayerViewController {
    
    override func viewDidDisappear(_ animated: Bool) {
        handleVideoCloseForCurrentState()
    }
    
    var parentView: UIViewController?
    var videoIdx: Int?
    
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
            if funnelProgress == .completedVideo2Bought {
                parentView?.tabBarController?.selectedIndex = 4
            } else { return }
        }
        
        if let _ = parentView as? FlashCardController {
            if funnelProgress == .completedVideo1 {
                AdManager.shared.showAdPopUP(parentVC: parentView!)
            } else if funnelProgress == .completedVideo2Bought {
                parentView?.tabBarController?.selectedIndex = 4
            } else { return }
        }
        
        if let _ = parentView as? DeckSelectingController {
            if funnelProgress == .completedVideo1 {
                AdManager.shared.showAdPopUP(parentVC: parentView!)
            } else if funnelProgress == .completedVideo2Bought {
                parentView?.tabBarController?.selectedIndex = 4
            } else { return }
        }
    }

}
