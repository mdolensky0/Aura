//
//  TestResultPopUpView.swift
//  Aura
//
//  Created by Maxwell Dolensky on 10/19/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

protocol TestResultPopUpDelegate {
    func done()
    func restart()
}

class TestResultPopUpView: UIView {
    
    var delegate: TestResultPopUpDelegate?
    
    // MARK: - SubViews
    var scoreLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 46, weight: .bold)
        l.text = "100%"
        l.textColor = K.DesignColors.primary
        return l
    }()
    
    var mainLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 1
        l.text = "Great Job!"
        l.textColor = K.DesignColors.purpleGrey
        l.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        return l
    }()
    
    var subLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.text = "You got a perfect score!"
        l.textColor = K.DesignColors.purpleGrey
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var restartButton: AnimatedButton = {
        let b = AnimatedButton(frame: .zero)
        b.isFlat = true
        b.backgroundColor = K.DesignColors.primary
        b.tintColor = .white
        b.setTitle("Restart", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        b.addTarget(self, action: #selector(restart(_:)), for: .touchUpInside)
        return b
    }()
    
    var doneButton: AnimatedButton = {
        let b = AnimatedButton(frame: .zero)
        b.isFlat = true
        b.backgroundColor = K.DesignColors.primary
        b.tintColor = .white
        b.setTitle("Done", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        b.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        return b
    }()
    
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup
    func setup() {
        self.backgroundColor = .white
        self.roundCorners(cornerRadius: 10)
        
        self.addSubview(scoreLabel)
        self.addSubview(mainLabel)
        self.addSubview(subLabel)
        self.addSubview(restartButton)
        self.addSubview(doneButton)
        
        scoreLabel.anchor(top: self.topAnchor,
                          bottom: nil,
                          leading: self.leadingAnchor,
                          trailing: self.trailingAnchor,
                          height: nil,
                          width: nil,
                          padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        
        mainLabel.anchor(top: scoreLabel.bottomAnchor,
                          bottom: nil,
                          leading: self.leadingAnchor,
                          trailing: self.trailingAnchor,
                          height: nil,
                          width: nil,
                          padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        
        subLabel.anchor(top: mainLabel.bottomAnchor,
                          bottom: nil,
                          leading: self.leadingAnchor,
                          trailing: self.trailingAnchor,
                          height: nil,
                          width: nil,
                          padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        
        restartButton.anchor(top: subLabel.bottomAnchor,
                             bottom: nil,
                             leading: self.leadingAnchor,
                             trailing: self.trailingAnchor,
                             height: 40,
                             width: nil,
                             padding: UIEdgeInsets(top: 50, left: 30, bottom: 0, right: -30))
        
        doneButton.anchor(top: restartButton.bottomAnchor,
                          bottom: self.bottomAnchor,
                             leading: self.leadingAnchor,
                             trailing: self.trailingAnchor,
                             height: 40,
                             width: nil,
                             padding: UIEdgeInsets(top: 20, left: 30, bottom: -30, right: -30))
        
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive = true
    }
    
    func setupLabelsFromScore(_ score: Double) {
        
        let percentText = String(format: "%.1f", score) + "%"
        scoreLabel.text = percentText
        
        if score == 100 {
            mainLabel.text = "Great Job!"
            subLabel.text = "You got a perfect score!"
        } else if score > 80 {
            mainLabel.text = "Awesome!"
            subLabel.text = "Almost there"
        } else if score > 70 {
            mainLabel.text = "Nice!"
            subLabel.text = "Keep up the good work!"
        } else {
            mainLabel.text = "You got this!"
            subLabel.text = "Keep studying"
        }
        
    }
    
    // MARK: - Selector Functions
    @objc func restart(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
        } completion: { (_) in
            self.delegate?.restart()
        }
    }
    
    @objc func done(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
        } completion: { (_) in
            self.delegate?.done()
        }
    }
    
}
