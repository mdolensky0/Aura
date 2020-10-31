//
//  PopUpManager.swift
//  Aura
//
//  Created by Maxwell Dolensky on 10/19/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

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
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
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
