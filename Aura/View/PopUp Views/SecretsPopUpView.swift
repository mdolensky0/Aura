//
//  SecretsPopUpView.swift
//  Aura
//
//  Created by Maxwell Dolensky on 2/3/21.
//  Copyright © 2021 Max Dolensky. All rights reserved.
//

import UIKit

protocol SecretsTutorialDelegate {
    func dismiss(didSkip: Bool)
    func playVideo()
}

class SecretsPopUpView: UIView {
    
    var delegate: SecretsTutorialDelegate?
    let fontSize: CGFloat = UIScreen.main.bounds.height > 667 ? 17 : 15
    
    var titleText = "Welcome to Aura!"
    var infoText = ""
    var thumbnailURL: String?
    var buttonText = ""
    
    let title: UILabel = {
        let l = UILabel()
        l.text = "Welcome to Aura!"
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.textAlignment = .center
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    lazy var info: UILabel = {
        let l = UILabel()
        l.text = "Get started with Aura by checking out this tutorial video"
        l.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        l.numberOfLines = 0
        return l
    }()
    
    var thumbnailView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var introVideoView: UIView = {
        
        let container = UIView()
        
        let play = UIImageView()
        play.backgroundColor = .white
        
        if #available(iOS 13, *) {
            play.image = UIImage.init(systemName: "play.fill")
        } else {
            play.image = #imageLiteral(resourceName: "play.fill").withRenderingMode(.alwaysTemplate)
        }
        
        play.tintColor = K.DesignColors.primary
        play.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        play.roundCorners(cornerRadius: 30)
        play.contentMode = .center
        
        play.translatesAutoresizingMaskIntoConstraints = false
        play.heightAnchor.constraint(equalToConstant: 60).isActive = true
        play.widthAnchor.constraint(equalToConstant: 60).isActive = true
        play.alpha = 0.7
        
        
        
        container.addSubview(thumbnailView)
        
        thumbnailView.anchor(top: container.topAnchor,
                             bottom: container.bottomAnchor,
                             leading: container.leadingAnchor,
                             trailing: container.trailingAnchor,
                             height: nil,
                             width: nil)
        
        thumbnailView.roundCorners(cornerRadius: 10)
        
        container.addSubview(play)
        
        play.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        play.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        let b = AnimatedButton(frame: .zero)
        b.addTarget(self, action: #selector(introVideoPressed(_:)), for: .touchUpInside)
        
        container.addSubview(b)
        b.anchor(top: container.topAnchor,
                 bottom: container.bottomAnchor,
                 leading: container.leadingAnchor,
                 trailing: container.trailingAnchor,
                 height: nil,
                 width: nil)
        
        return container
        
    }()
    
    let watchButton: AnimatedButton = {
        let b = AnimatedButton()
        b.isFlat = true
        b.setTitle("Watch Tutorial", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        b.backgroundColor = K.DesignColors.primary
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 50).isActive = true
        b.widthAnchor.constraint(equalToConstant: 240).isActive = true
        b.addTarget(self, action: #selector(watchButtonPressed(_:)), for: .touchUpInside)
        return b
    }()
    
    let skipButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("skip", for: .normal)
        b.setTitleColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        return b
    }()
    
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(frame: CGRect, titleText: String, infoText: String, thumbnailURL: String, buttonText: String) {
        self.init(frame: frame)
        
        self.titleText = titleText
        self.infoText = infoText
        self.thumbnailURL = thumbnailURL
        self.buttonText = buttonText
        
        self.title.text = titleText
        self.info.text = infoText
        self.thumbnailView.loadImageUsingCacheWithURLString(urlString: thumbnailURL)
        self.watchButton.setTitle(buttonText, for: .normal)
        
        Utilities.shared.popUpDelegate = self
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        
        if UIScreen.main.bounds.height > 667 {
            setupForLargerScreen()
        } else {
            setupForSmallerScreen()
        }
        
    }
    
    func setupForLargerScreen() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        self.backgroundColor = .white
        self.roundCorners(cornerRadius: 10)
        
        self.addSubview(skipButton)
        self.addSubview(title)
        self.addSubview(info)
        self.addSubview(introVideoView)
        self.addSubview(watchButton)
        
        skipButton.anchor(top: self.topAnchor,
                          bottom: nil,
                          leading: nil,
                          trailing: self.trailingAnchor,
                          height: nil,
                          width: nil,
                          padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: -8))
        
        title.anchor(top: skipButton.bottomAnchor,
                     bottom: nil,
                     leading: self.leadingAnchor,
                     trailing: self.trailingAnchor,
                     height: nil,
                     width: nil,
                     padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        
        info.anchor(top: title.bottomAnchor,
                    bottom: nil,
                    leading: self.leadingAnchor,
                    trailing: self.trailingAnchor,
                    height: nil,
                    width: nil,
                    padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        
        introVideoView.anchor(top: info.bottomAnchor,
                              bottom: nil,
                              leading: self.leadingAnchor,
                              trailing: self.trailingAnchor,
                              height: nil,
                              width: nil,
                              padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        
        introVideoView.heightAnchor.constraint(equalTo: introVideoView.widthAnchor, multiplier: 0.5).isActive = true
        
        watchButton.topAnchor.constraint(equalTo: introVideoView.bottomAnchor, constant: 40).isActive = true
        watchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        watchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -35).isActive = true
        
    }
    
    func setupForSmallerScreen() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        self.backgroundColor = .white
        self.roundCorners(cornerRadius: 10)
        
        self.addSubview(skipButton)
        self.addSubview(title)
        self.addSubview(info)
        self.addSubview(introVideoView)
        self.addSubview(watchButton)
        
        skipButton.anchor(top: self.topAnchor,
                          bottom: nil,
                          leading: nil,
                          trailing: self.trailingAnchor,
                          height: nil,
                          width: nil,
                          padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: -8))
        
        title.anchor(top: skipButton.bottomAnchor,
                     bottom: nil, leading: self.leadingAnchor,
                     trailing: self.trailingAnchor,
                     height: nil,
                     width: nil,
                     padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: -20))
        
        info.anchor(top: title.bottomAnchor,
                    bottom: nil,
                    leading: self.leadingAnchor,
                    trailing: self.trailingAnchor,
                    height: nil,
                    width: nil,
                    padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: -20))
        
        introVideoView.anchor(top: info.bottomAnchor,
                              bottom: nil,
                              leading: self.leadingAnchor,
                              trailing: self.trailingAnchor,
                              height: nil,
                              width: nil,
                              padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: -20))
        
        watchButton.topAnchor.constraint(equalTo: introVideoView.bottomAnchor, constant: 20).isActive = true
        watchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        watchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -35).isActive = true
        
    }
        
    @objc func introVideoPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            
            sender.superview?.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.3
            
        } completion: { (_) in
            
            self.delegate?.playVideo()
        }
    }
    
    @objc func watchButtonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            
            sender.transform = .identity
            
        } completion: { (_) in
            
            self.delegate?.playVideo()
        }
    }
    
    @objc func dismiss(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = .identity
        } completion: { (_) in
            self.delegate?.dismiss(didSkip: true)
        }
    }
    
}

extension SecretsPopUpView: FirebaseUpdaterDelegate {
    func updateSecretsThumbnail() {
        self.thumbnailView.loadImageUsingCacheWithURLString(urlString: AdManager.shared.getFunnelThumbnailURLForCurrentUserState())
    }
}
