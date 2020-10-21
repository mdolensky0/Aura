//
//  TutorialController.swift
//  Aura
//
//  Created by Maxwell Dolensky on 10/20/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class TutorialController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Views
    let previousButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("PREV", for: .normal)
        b.setTitleColor(K.DesignColors.purpleGrey, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return b
    }()
    
    let nextButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("NEXT", for: .normal)
        b.setTitleColor(K.DesignColors.primary, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return b
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.currentPageIndicatorTintColor = K.DesignColors.primary
        pc.pageIndicatorTintColor = UIColor(red: 217/255, green: 199/255, blue: 242/255, alpha: 1)
        return pc
    }()
    
    let bottomControlsStackView: UIStackView = {
        
        let sv = UIStackView()
        sv.distribution = .fillEqually
        return sv
        
    }()
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        collectionView.register(TutorialCell.self, forCellWithReuseIdentifier: "tutorialCell")
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        
        view.addSubview(bottomControlsStackView)
        bottomControlsStackView.anchor(top: nil,
                                       bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                       leading: view.safeAreaLayoutGuide.leadingAnchor,
                                       trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                       height: 50,
                                       width: nil)
        
        bottomControlsStackView.addArrangedSubview(previousButton)
        bottomControlsStackView.addArrangedSubview(pageControl)
        bottomControlsStackView.addArrangedSubview(nextButton)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorialCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
