//
//  FlashCardController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class FlashCardController: UIViewController {

    // MARK: - Views
    var centerTitle: UILabel = {
       
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        label.backgroundColor = .clear
        label.font = UIFont(name: K.Fonts.avenirBlack, size: 17)
        label.text = "Decks"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var mainScrollView = VerticalScrollView(frame: .zero)
    
    var createNewDeckButton: UIView = {
        
        let background = UIView()
        
        let view = UIView()
        view.backgroundColor = .white
        
        let container = UIView()
        container.backgroundColor = .white
        
        let imageView = UIImageView()
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: "plus.circle.fill")
        } else {
            imageView.image = #imageLiteral(resourceName: "plus.circle").withRenderingMode(.alwaysTemplate)
        }
        imageView.tintColor = K.DesignColors.primary
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let constant = UIScreen.main.bounds.width > 320 ? 40 : 30
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(constant)).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: CGFloat(constant)).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        
        let label = UILabel()
        label.text = "Create New Deck"
        if UIScreen.main.bounds.width > 320 {
            label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        } else {
            label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        }
        
        label.textAlignment = .left
        label.textColor = .black
        label.backgroundColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        
        let button: AnimatedButton = {
            
            let b = AnimatedButton(frame: .zero)
            b.backgroundColor = .clear
            b.addTarget(self, action: #selector(createNewDeck(_:)), for: .touchUpInside)
            return b
            
        }()
        
        container.addSubview(imageView)
        container.addSubview(label)
        
        imageView.anchor(top: container.topAnchor,
                         bottom: container.bottomAnchor,
                         leading: container.leadingAnchor,
                         trailing: nil,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0))
        
        label.anchor(top: container.topAnchor,
                     bottom: container.bottomAnchor,
                     leading: imageView.trailingAnchor,
                     trailing: container.trailingAnchor,
                     height: nil,
                     width: nil,
                     padding: UIEdgeInsets(top: 20, left: 20, bottom: -20, right: 0))
        

        view.roundCorners(cornerRadius: 10)
        
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor).isActive = true
        container.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true
        container.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        background.addSubview(view)
        
        view.anchor(top: background.topAnchor,
                    bottom: background.bottomAnchor,
                    leading: background.leadingAnchor,
                    trailing: background.trailingAnchor,
                    height: nil,
                    width: nil)
        
        view.addSubview(button)
        
        button.anchor(top: view.topAnchor,
                      bottom: view.bottomAnchor,
                      leading: view.leadingAnchor,
                      trailing: view.trailingAnchor,
                      height: nil,
                      width: nil)
                
        return background
        
    }()
    
    var popularFlashcardScrollView: PopularDecksScrollView!
    
    var popularFlashcardLabel: UILabel = {
        
        let l = UILabel()
        l.text = "Popular Flashcards"
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.textColor = .black
        return l
        
    }()
    
    var myDecksLabel: UILabel = {
        
        let l = UILabel()
        l.text = "My Decks"
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.textColor = .black
        return l
        
    }()
    
    var myDecksScrollView: MyDecksScrollView!
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        
        createNewDeckButton.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        
        for v in popularFlashcardScrollView.stackView.subviews {
            v.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
        for v in myDecksScrollView.stackView.subviews {
            v.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
    }
      
    // MARK: - Setup
    func setup() {
        
        Utilities.shared.decksDelegate = self
        
        view.backgroundColor = K.DesignColors.background
        
        // Setup Navigation Bar
        self.navigationItem.titleView = centerTitle
        
        // Add UserButton
        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(settingsButtonTapped))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "line.horizontal.3").withRenderingMode(.alwaysTemplate),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(settingsButtonTapped))
        }
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.DesignColors.primary
        
        // Initialize My Decks Scroll View
        if let decks = Utilities.shared.user?.decks {
            myDecksScrollView = MyDecksScrollView(frame: .zero, decks: decks)
            myDecksScrollView.myDeckDelegate = self
        } else {
            myDecksScrollView = MyDecksScrollView(frame: .zero)
            myDecksScrollView.myDeckDelegate = self
        }
        
        // Initialize Popular Decks Scroll View
        if let decks = Utilities.shared.superUser?.decks {
            popularFlashcardScrollView = PopularDecksScrollView(frame: .zero, decks: decks)
            popularFlashcardScrollView.popularDeckDelegate = self
        } else {
            popularFlashcardScrollView = PopularDecksScrollView(frame: .zero)
            popularFlashcardScrollView.popularDeckDelegate = self
            
            FirebaseManager.shared.loadSuperUser { (superUser) in
                Utilities.shared.superUser = superUser
            }
        }
        
        view.addSubview(mainScrollView)
        mainScrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              bottom: view.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              height: nil,
                              width: nil)
        
        // Add Create New Deck Button
        mainScrollView.stackView.addArrangedSubview(createNewDeckButton, withMargin: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(popularFlashcardLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(popularFlashcardScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(myDecksLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(myDecksScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
    }
    
    //MARK: - Selector Functions
    @objc func settingsButtonTapped() {
    
        Utilities.shared.settingsLauncher.parentVC = self
        Utilities.shared.settingsLauncher.showSettings()
                
    }
    
    @objc func createNewDeck(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.superview?.transform = .identity
            sender.superview?.superview?.layer.shadowOpacity = 0.3
        }
        
        var textField = UITextField()
        
        // Main Alert
        let alert = UIAlertController(title: "Add New Flashcard Deck", message: "", preferredStyle: .alert)
        
        // Action: Create New Deck
        let action = UIAlertAction(title: "Add Deck", style: .default) { (action) in
            
            if textField.text != nil && textField.text!.count > 0 {
                
                let newDeckName = Utilities.shared.getUniqueDeckName(from: textField.text!, given: Utilities.shared.user!.decks)
                
                // Create New Deck And Save To Firebase
                let newDeck = DeckModel(name: newDeckName)
                Utilities.shared.user?.decks.append(newDeck)
                
                FirebaseManager.shared.updateUser(user: Utilities.shared.user!)
                
            }
        }
        
        // Action: Cancel
        let action1 = UIAlertAction(title: "Cancel", style: .default) { (action) in
            return
        }
        
        // Add TextField to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Deck Name"
            textField = alertTextField
        }
        
        // Add Actions and Present
        alert.addAction(action)
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
        
    }
}

extension FlashCardController: DeckUpdater {
    
    func updateMyDecks() {
        
        guard let decks = Utilities.shared.user?.decks else {
            
            myDecksScrollView.decks = []
            myDecksScrollView.updateDecks()
            myDecksScrollView.updateVisibility()
            myDecksLabel.superview?.isHidden = true
            return
            
        }
        
        myDecksScrollView.decks = decks
        myDecksScrollView.updateDecks()
        myDecksScrollView.updateVisibility()
                
        if decks.count == 0 {
            myDecksLabel.superview?.isHidden = true
        } else { myDecksLabel.superview?.isHidden = false }
    }
    
    func updatePopularDecks() {
        
        guard let decks = Utilities.shared.superUser?.decks else { return }
        
        popularFlashcardScrollView.decks = decks
        popularFlashcardScrollView.updateDecks()
        popularFlashcardScrollView.updateVisibility()
        
        if decks.count == 0 {
            popularFlashcardLabel.superview?.isHidden = true
        } else { popularFlashcardLabel.superview?.isHidden = false }
        
    }
}

extension FlashCardController: MyDeckDelegate, PopularDeckDelegate {
    
    func goToDeck(deckIndex: Int) {
        let vc = DeckController()
        vc.myDeck = Utilities.shared.user?.decks[deckIndex]
        vc.myDeckIndex = deckIndex
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPurchasePopUp(deckIndex: Int) {
        print("puchasing deck \(deckIndex)")
    }
    
}


