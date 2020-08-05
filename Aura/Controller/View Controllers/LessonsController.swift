//
//  LessonsController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class LessonsController: UIViewController {

    var comingSoon: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        label.text = "Coming Soon! \nRefer to search tab"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(comingSoon)
        comingSoon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        comingSoon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    

}
