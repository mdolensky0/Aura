//
//  KeyCardView.swift
//  Aura
//
//  Created by Max Dolensky on 7/28/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import AVFoundation

class KeyCardView: UIView {
    
    // Data
    var audioString: String?
    var color: UIColor?
    var text: String?
    
    // Subviews
    var contentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners(cornerRadius: 20)
        return view
        
    }()
    
    var colorCircle: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        view.widthAnchor.constraint(equalToConstant: 150).isActive = true
        view.roundCorners(cornerRadius: 150/2)
        return view
        
    }()
    
    var textLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 140, weight: .medium)
        label.backgroundColor = .white
        label.textColor = .black
        return label
        
    }()
    
    var soundButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.3.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(soundButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.imageView?.contentMode = .scaleAspectFit
        return button
        
    }()
    
    var learnMoreButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(learnMoreButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.imageView?.contentMode = .scaleAspectFit
        return button
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    convenience init(frame: CGRect, audioString: String, color: UIColor, text: String?) {
        self.init(frame: frame)
        self.audioString = audioString
        self.color = color
        self.text = text
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    func setupView() {
        
        // Background and Shadow
        self.backgroundColor = .white
        self.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 0, height: 0), radius: 3)
        
        // Fix the width and height of the card
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 214).isActive = true
        self.heightAnchor.constraint(equalToConstant: 264).isActive = true
        
        // Add subviews
        self.addSubview(contentView)
        self.addSubview(soundButton)
        self.addSubview(learnMoreButton)
        
        // If there is text there is no color circle
        if self.text != nil {
            
            self.addSubview(textLabel)
            textLabel.text = self.text
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: soundButton.topAnchor, constant: -20).isActive = true
        }
        
        else {
            
            self.addSubview(colorCircle)
            colorCircle.backgroundColor = self.color
            colorCircle.translatesAutoresizingMaskIntoConstraints = false
            colorCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            colorCircle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            colorCircle.bottomAnchor.constraint(lessThanOrEqualTo: soundButton.topAnchor, constant: -20).isActive = true
            
        }
        
        contentView.anchor(top: self.topAnchor,
                           bottom: self.bottomAnchor,
                           leading: self.leadingAnchor,
                           trailing: self.trailingAnchor,
                           height: nil,
                           width: nil)
        
        soundButton.anchor(top: nil,
                           bottom: contentView.bottomAnchor,
                           leading: contentView.leadingAnchor,
                           trailing: nil,
                           height: nil,
                           width: nil,
                           padding: UIEdgeInsets(top: 40, left: 40, bottom: -25, right: 0))
        
        learnMoreButton.anchor(top: nil,
                               bottom: soundButton.bottomAnchor,
                               leading: nil,
                               trailing: contentView.trailingAnchor,
                               height: nil,
                               width: nil,
                               padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -40))
        
        soundButton.trailingAnchor.constraint(lessThanOrEqualTo: learnMoreButton.leadingAnchor, constant: -20).isActive = true
        
        if color == K.Colors.lightGrey || color == K.Colors.yellow {
            soundButton.tintColor = K.Colors.lightGrey
            soundButton.isUserInteractionEnabled = false
        }

    }
    
    @objc func soundButtonPressed(_ sender: UIButton) {
        
        if let audioString = audioString {
            
            Utilities.shared.playSound(audioString)
            
        }
    }
    
    @objc func learnMoreButtonPressed(_ sender: UIButton) {
        print("learning more")
    }
    
}
