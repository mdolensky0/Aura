//
//  SearchStatusView.swift
//  Aura
//
//  Created by Max Dolensky on 8/27/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class SearchStatusView: UIView {
    
    // Error Messages
    let success = "Success!"
    
    let nilTranslation = "Unable to translate.\n\nPlease check your network connection."
    
    let emptyTranslationNoExistingWordModels = "No translation found.\n\nPlease check your input/output language parameters and spelling.\n\nUnable to color any words.\n\nPlease check spelling.\n\nOtherwise, we apologize, these words do not exist in our database yet."
    
    let emptyTranslationMissingSomeWordModels = "No translation found.\n\nPlease check your input/output language parameters and spelling.\n\nUnable to color some words.\n\nPlease check spelling.\n\nOtherwise, we apologize, these words do not exist in our database yet."
    
    let emptyTranslationWithAllWordModels = "No translation found.\n\nPlease check your input/output language parameters."
    
    let noExistingWordModels = "Unable to color any words.\n\nPlease check your network connection and spelling.\n\nOtherwise, we apologize, these words do not exist in our database yet."
    
    let missingSomeWordModels = "Unable to color some words.\n\nPlease check your spelling.\n\nOtherwise, we apologize, these words do not exist in our database yet."
    
    let colorError = "We noticed a word may be colored incorrectly. We will try and fix this as soon as possible!"
    
    // Subviews
    let errLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = K.DesignColors.error
        label.backgroundColor = .clear
        return label
        
    }()
    
    let container: UIView = {
        
        let v = UIView()
        v.backgroundColor = .white
        v.roundCorners(cornerRadius: 10)
        return v
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        container.addSubview(errLabel)
        
        errLabel.translatesAutoresizingMaskIntoConstraints = false
        errLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        errLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        errLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        errLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
        errLabel.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: 20).isActive = true
        errLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -20).isActive = true
        
        self.addSubview(container)
        container.anchor(top: self.topAnchor,
                         bottom: self.bottomAnchor,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil)
    }
    
    func setLabelText(status: SearchStatus) {
        
        switch status {
            
        case .success:
            
            errLabel.text = success
            
        case .nilTranslation:
            
            errLabel.text = nilTranslation
            
        case .emptyTranslationNoExistingWordModels:
            
            errLabel.text = emptyTranslationNoExistingWordModels
            
        case .emptyTranslationMissingSomeWordModels:
            
            errLabel.text = emptyTranslationMissingSomeWordModels
            
        case .emptyTranslationWithAllWordModels:
            
            errLabel.text = emptyTranslationWithAllWordModels
            
        case .noExistingWordModels:
            
            errLabel.text = noExistingWordModels
            
        case .missingSomeWordModels:
            
            errLabel.text = missingSomeWordModels
        }
    }
    
    func setLabelTextAsColorErr() {
        
        errLabel.text = colorError
        
    }
}
