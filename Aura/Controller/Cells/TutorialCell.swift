//
//  TutorialCell.swift
//  Aura
//
//  Created by Maxwell Dolensky on 10/20/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class TutorialCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .purple
        return iv
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Here is the title Label"
        return l
    }()
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = .gray
        l.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        l.text = "This is the description label. it will provide more explanation than the title"
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        
        
        
    }
    
}
