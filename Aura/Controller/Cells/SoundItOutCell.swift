//
//  SoundItOutCell.swift
//  Aura
//
//  Created by Max Dolensky on 7/13/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class SoundItOutCell: UICollectionViewCell {
    
    static let identifier = "SoundItOutCell"
    
    var soundButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .purple
        return button
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {

        self.addSubview(soundButton)
        
        soundButton.anchor(top: self.topAnchor,
                           bottom: self.bottomAnchor,
                           leading: self.leadingAnchor,
                           trailing: self.trailingAnchor,
                           height: nil,
                           width: nil)
        
        soundButton.addTarget(self, action: #selector(soundItOutButtonPressed), for: .touchUpInside)
        soundButton.roundCorners(cornerRadius: 6)
    }
    
    @objc func soundItOutButtonPressed() {
        print("Ah")
    }

}
