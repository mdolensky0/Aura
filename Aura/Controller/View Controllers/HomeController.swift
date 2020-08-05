//
//  HomeViewController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    var comingSoon: UILabel = {
        
        let label = UILabel()
        let text = NSMutableAttributedString(string: "Aura")
        text.addAttribute(.foregroundColor, value: K.Colors.purple, range: NSRange(location: 0, length: 2))
        text.addAttribute(.foregroundColor, value: K.Colors.darkGrey, range: NSRange(location: 2, length: 1))
        text.addAttribute(.foregroundColor, value: K.Colors.lightPink, range: NSRange(location: 3, length: 1))
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 60, weight: .bold), range: NSRange(location: 0, length: text.length))
        label.numberOfLines = 1
        label.textAlignment = .center
        label.attributedText = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    var referLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.text = "start at search tab"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(comingSoon)
        view.addSubview(referLabel)
        comingSoon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        comingSoon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        referLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        referLabel.topAnchor.constraint(equalTo: comingSoon.topAnchor, constant: 100).isActive = true
        
    }
    

}
