//
//  VideoCell.swift
//  Aura
//
//  Created by Max Dolensky on 9/2/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    static let identifier = "VideoCell"
    
    var imageView: UIImageView = {
        
        let iv = UIImageView()
        iv.backgroundColor = K.DesignColors.primary
        iv.roundCorners(cornerRadius: 6)
        iv.layer.borderWidth = 1
        iv.layer.borderColor = K.DesignColors.primary.cgColor
        return iv
        
    }()
    
    var titleLabel: UILabel = {
        
        let l = UILabel()
        l.text = "Video Title"
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return l
        
    }()
    
    var videoLengthLabel: UILabel = {
        
        let l = UILabel()
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.text = "0 minutes, 0 seconds"
        l.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return l
        
    }()
    
    var cellMask: UIView = {
        
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        return v
        
    }()
    
    override var isHighlighted: Bool {
        
        didSet {
            
            if isHighlighted {
                
                self.cellMask.alpha = 0.5
                
            }
            
            else {
                
                self.cellMask.alpha = 0.0
                
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {

        self.addSubview(imageView)
        
        imageView.anchor(top: self.topAnchor,
                         bottom: self.bottomAnchor,
                         leading: self.leadingAnchor,
                         trailing: nil,
                         height: nil,
                         width: 96,
                         padding: UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 0))
        
        let container = UIView()
        container.addSubview(titleLabel)
        container.addSubview(videoLengthLabel)
        
        titleLabel.anchor(top: container.topAnchor,
                          bottom: nil,
                          leading: container.leadingAnchor,
                          trailing: container.trailingAnchor,
                          height: nil,
                          width: nil)
        
        videoLengthLabel.anchor(top: titleLabel.bottomAnchor,
                                bottom: container.bottomAnchor,
                                leading: titleLabel.leadingAnchor,
                                trailing: titleLabel.trailingAnchor,
                                height: nil,
                                width: nil,
                                padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0))
        
        self.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
        container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        
        let lineDivider = UIView()
        lineDivider.backgroundColor = K.Colors.lightGrey
        
        self.addSubview(lineDivider)
        lineDivider.anchor(top: nil,
                           bottom: self.bottomAnchor,
                           leading: imageView.leadingAnchor,
                           trailing: self.trailingAnchor,
                           height: 1,
                           width: nil)
        
        self.addSubview(cellMask)
        
        cellMask.anchor(top: self.topAnchor,
                        bottom: self.bottomAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        height: nil,
                        width: nil)
    }
    
}

