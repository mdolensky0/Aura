//
//  FlashCardController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class FlashCardController: UIViewController {

    //Data
    var popularDecks: [UIImage] = [#imageLiteral(resourceName: "californiaSlang"), #imageLiteral(resourceName: "flirting")]
    var myDecks = [DeckModel]()
    
    
    // Subviews
    var centerTitle: UILabel = {
       
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.backgroundColor = K.Colors.purple
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Decks"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var mainScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = K.Colors.lightGrey
        return scrollView
        
    }()
        
    var mainStackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        return stackView
        
    }()
    
    var createNewDeckButton: UIView = {
        
        let background = UIView()
        
        let view = UIView()
        view.backgroundColor = .white
        
        let container = UIView()
        container.backgroundColor = .white
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.tintColor = K.Colors.purple
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        
        let label = UILabel()
        label.text = "Create New Deck"
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textAlignment = .left
        label.textColor = .black
        label.backgroundColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        
        let button: UIButton = {
            
            let button = UIButton()
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(createNewDeck(_:)), for: .touchUpInside)
            return button
            
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
    
    var popularDecksScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = K.Colors.lightGrey
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.masksToBounds = false
        return scrollView
        
    }()
    
    var popularDecksContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = K.Colors.lightGrey
        return view
        
    }()
    
    var popularDecksStackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.masksToBounds = false
        return stackView
        
    }()
    
    var popularDecksHeaderLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = K.Colors.lightGrey
        label.text = "Popular Decks"
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .left
        return label
        
    }()
    
    var myDecksScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = K.Colors.lightGrey
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.masksToBounds = false
        return scrollView
        
    }()
    
    var myDecksContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = K.Colors.lightGrey
        return view
        
    }()
    
    var myDecksStackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.masksToBounds = false
        return stackView
        
    }()
    
    var myDecksHeaderLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = K.Colors.lightGrey
        label.text = "My Decks"
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .left
        return label
        
    }()
    
    // View Lifetime Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.shared.delegate = self
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        
        createNewDeckButton.setShadow(color: .black, opacity: 0.5, offset: .zero, radius: 2)
        
        for view in popularDecksStackView.arrangedSubviews {
            view.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
        for view in myDecksStackView.arrangedSubviews {
            view.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateMyDecksStackView()
    }
    
    func setup() {
        
        view.backgroundColor = .white
        
        // Setup Navigation Bar
        self.navigationItem.titleView = centerTitle
        
        // Add UserButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(profileButtonTapped))
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.Colors.purple
        
        // Add Scroll and Stack View
        setupScrollView()
        
        // Add Create New Deck Button
        mainStackView.addArrangedSubview(createNewDeckButton, withMargin: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        
        // Setup Popular Decks Header and Scroll View
        setupPopularDecksScrollView()
        
        // Setup My Decks Header and Scroll View
        setupMyDecksScrollView()

    }
    
    func setupScrollView() {
        
        // Add scroll view and content view
        view.addSubview(mainScrollView)
        view.sendSubviewToBack(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        
        // Anchor Scroll View
        mainScrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          height: nil,
                          width: nil)
        
        // Anchor Content View
        mainStackView.anchor(top: mainScrollView.topAnchor,
                           bottom: mainScrollView.bottomAnchor,
                           leading: mainScrollView.leadingAnchor,
                           trailing: mainScrollView.trailingAnchor,
                           height: nil,
                           width: nil)
        
        mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
    }
    
    func setupPopularDecksScrollView() {
        
        // Add Header Label and Scroll View to the Main Content View
        mainStackView.addArrangedSubview(popularDecksHeaderLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        mainStackView.addArrangedSubview(popularDecksScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        // Add Stack View to Scroll View
        popularDecksScrollView.addSubview(popularDecksStackView)
        
        // Anchor StackView Within Scroll View
        popularDecksStackView.anchor(top: popularDecksScrollView.topAnchor,
                                     bottom: popularDecksScrollView.bottomAnchor,
                                     leading: popularDecksScrollView.leadingAnchor,
                                     trailing: popularDecksScrollView.trailingAnchor,
                                     height: nil,
                                     width: nil)
        
        // Prevent Vertical Scrolling
        popularDecksStackView.heightAnchor.constraint(equalTo: popularDecksScrollView.heightAnchor).isActive = true
        
        
        // Populate Alternative Translations Stack View
        populatePopularDecksStackView()

        
    }
    
    func populatePopularDecksStackView() {
        
        if popularDecks.count == 0 {
            
            popularDecksHeaderLabel.superview?.isHidden = true
            popularDecksScrollView.superview?.isHidden = true
            
        }
        
        else {
            
            popularDecksHeaderLabel.superview?.isHidden = false
            popularDecksScrollView.superview?.isHidden = false
            
        }
        
        for deckImage in popularDecks {
            
            // Create Deck Image View
            let imageView = UIImageView()
            imageView.image = deckImage
            imageView.contentMode = .scaleAspectFit
            imageView.roundCorners(cornerRadius: 10)

            
            let background = UIView()
            background.backgroundColor = .white
            background.translatesAutoresizingMaskIntoConstraints = false
            background.widthAnchor.constraint(equalToConstant: 200).isActive = true
            background.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            background.addSubview(imageView)
            imageView.anchor(top: background.topAnchor,
                             bottom: background.bottomAnchor,
                             leading: background.leadingAnchor,
                             trailing: background.trailingAnchor,
                             height: nil,
                             width: nil)
            
            popularDecksStackView.addArrangedSubview(background)
            
        }
        
    }
    
    func setupMyDecksScrollView() {
        
        // Add Header Label and Scroll View to the Main Content View
        mainStackView.addArrangedSubview(myDecksHeaderLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        mainStackView.addArrangedSubview(myDecksScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        // Add Stack View to Scroll View
        myDecksScrollView.addSubview(myDecksStackView)
        
        // Anchor StackView Within Scroll View
        myDecksStackView.anchor(top: myDecksScrollView.topAnchor,
                                     bottom: myDecksScrollView.bottomAnchor,
                                     leading: myDecksScrollView.leadingAnchor,
                                     trailing: myDecksScrollView.trailingAnchor,
                                     height: nil,
                                     width: nil)
        
        // Prevent Vertical Scrolling
        myDecksStackView.heightAnchor.constraint(equalTo: myDecksScrollView.heightAnchor).isActive = true
        
        
        // Populate Alternative Translations Stack View
        populateMyDecksStackView()

    }
    
    func populateMyDecksStackView() {
        
        if let decks = Utilities.shared.user?.decks {
            
            myDecks = decks
            
        }
        
        for view in myDecksStackView.subviews {
            
            view.removeFromSuperview()
            
        }
        
        if myDecks.count == 0 {
            
            myDecksHeaderLabel.superview?.isHidden = true
            myDecksScrollView.superview?.isHidden = true
            
        }
        
        else {
            
            myDecksHeaderLabel.superview?.isHidden = false
            myDecksScrollView.superview?.isHidden = false
            
        }
        
        var index = 0
        for deck in myDecks {
            
            // Create Deck Image View
            let titleLabel = UILabel()
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .medium)
            titleLabel.textAlignment = .center
            titleLabel.text = deck.name
            
            let numCardsLabel = UILabel()
            numCardsLabel.numberOfLines = 1
            numCardsLabel.adjustsFontSizeToFitWidth = true
            numCardsLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            numCardsLabel.textAlignment = .left
            numCardsLabel.text = "\(deck.numberOfCards) cards"
            
            let percentageLabel = UILabel()
            percentageLabel.numberOfLines = 1
            percentageLabel.adjustsFontSizeToFitWidth = true
            percentageLabel.font = UIFont.systemFont(ofSize: 23, weight: .medium)
            percentageLabel.textAlignment = .right
            
            if deck.prevScore < 0 {
                
                percentageLabel.text = "-%"
                percentageLabel.textColor = .black
                
            }
            
            else if deck.prevScore >= 0 && deck.prevScore <= 50 {
                
                percentageLabel.text = "\(deck.prevScore)%"
                percentageLabel.textColor = K.Colors.red
                
            }
            
            else if deck.prevScore > 50  && deck.prevScore <= 69 {
                
                percentageLabel.text = "\(deck.prevScore)%"
                percentageLabel.textColor = K.Colors.orange
                
            }
            
            else if deck.prevScore > 69 && deck.prevScore <= 79 {
                
                percentageLabel.text = "\(deck.prevScore)%"
                percentageLabel.textColor = K.Colors.yellow
                
            }
            
            else if deck.prevScore > 79 && deck.prevScore <= 100 {
                
                percentageLabel.text = "\(deck.prevScore)%"
                percentageLabel.textColor = K.Colors.green
                
            }
            
            let contentView = UIView()
            contentView.backgroundColor = .white
            contentView.roundCorners(cornerRadius: 10)
            
            contentView.addSubview(titleLabel)
            contentView.addSubview(numCardsLabel)
            contentView.addSubview(percentageLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 20).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            
            numCardsLabel.anchor(top: nil,
                                 bottom: contentView.bottomAnchor,
                                 leading: contentView.leadingAnchor,
                                 trailing: nil,
                                 height: nil,
                                 width: nil,
                                 padding: UIEdgeInsets(top: 0, left: 10, bottom: -10, right: 0))
            
            percentageLabel.translatesAutoresizingMaskIntoConstraints = false
            percentageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            percentageLabel.firstBaselineAnchor.constraint(equalTo: numCardsLabel.firstBaselineAnchor).isActive = true
            percentageLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            
            numCardsLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            numCardsLabel.trailingAnchor.constraint(greaterThanOrEqualTo: percentageLabel.leadingAnchor, constant: 20).isActive = true
            
            let background = UIView()
            background.translatesAutoresizingMaskIntoConstraints = false
            background.widthAnchor.constraint(equalToConstant: 200).isActive = true
            background.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            background.addSubview(contentView)
            contentView.anchor(top: background.topAnchor,
                             bottom: background.bottomAnchor,
                             leading: background.leadingAnchor,
                             trailing: background.trailingAnchor,
                             height: nil,
                             width: nil)
            
            let button = UIButton()
            button.backgroundColor = .clear
            button.tag = index
            index += 1
            button.addTarget(self, action: #selector(deckPressed(_:)), for: .touchUpInside)
            
            contentView.addSubview(button)
            button.anchor(top: contentView.topAnchor,
                          bottom: contentView.bottomAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor,
                          height: nil,
                          width: nil)
            
            myDecksStackView.addArrangedSubview(background)
        
        }
        
    }
    
//MARK: - Selector Functions
    @objc func profileButtonTapped() {
        
        if Utilities.shared.isUserSignedIn {
            
            Utilities.shared.signUserOut(alertIn: self)
            
        }
        
        else {
            
            Utilities.shared.tabController?.selectedIndex = 3
            
        }

    }
    
    @objc func createNewDeck(_ sender: UIButton) {
        
        var textField = UITextField()
        
        // Main Alert
        let alert = UIAlertController(title: "Add New Flashcard Deck", message: "", preferredStyle: .alert)
        
        // Action: Create New Deck
        let action = UIAlertAction(title: "Add Deck", style: .default) { (action) in
            
            if textField.text != nil && textField.text!.count > 0 {
                
                let newDeckName = Utilities.shared.getUniqueDeckName(from: textField.text!, given: Utilities.shared.user!.decks)
                
                // Create New Deck And Save To Firebase
                let newDeck = DeckModel(name: newDeckName, numberOfCards: 0, prevScore: -1, cards: [FlashcardModel]())
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
    
    @objc func deckPressed(_ sender: UIButton) {
        
        let vc = DeckController()
        vc.myDeck = myDecks[sender.tag]
        vc.myDeckIndex = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

extension FlashCardController: DecksControllerDelegate {
    
    func updateMyDecks() {
        
        DispatchQueue.main.async {
            self.populateMyDecksStackView()
        }
    }
    
}
