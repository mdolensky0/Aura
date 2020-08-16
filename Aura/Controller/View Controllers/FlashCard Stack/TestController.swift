//
//  TestController.swift
//  Aura
//
//  Created by Max Dolensky on 8/5/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    
    //MARK: - Data
    var myDeck: DeckModel!
    var myDeckIndex: Int!
    var divisor: CGFloat!
    var isFront = true
    var isReverse = true
    var myQueue = [FlashcardModel]()
    
    //MARK: - Subviews
    
    var centerTitle: UILabel = {
       
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Deck Name"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    let contentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = K.Colors.lightGrey
        return view
        
    }()
        
    let imageContainer: UIView = {
                
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
        
    }()
    
    let imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = K.Colors.green
        imageView.image = UIImage(systemName: "checkmark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.roundCorners(cornerRadius: 10)
        return imageView
        
    }()
    
    let flashcardBackground = UIView()
    
    let XView: UIView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(systemName: "xmark")
        imageView.tintColor = K.Colors.red
        imageView.contentMode = .scaleAspectFit
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 70).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        view.roundCorners(cornerRadius: 35)
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let background = UIView()
        background.addSubview(view)
        view.anchor(top: background.topAnchor,
                    bottom: background.bottomAnchor,
                    leading: background.leadingAnchor,
                    trailing: background.trailingAnchor,
                    height: nil,
                    width: nil)
        
        return background
        
    }()
    
    let checkmarkView: UIView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = K.Colors.green
        imageView.contentMode = .scaleAspectFit
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 70).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        view.roundCorners(cornerRadius: 35)
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let background = UIView()
        background.addSubview(view)
        view.anchor(top: background.topAnchor,
                    bottom: background.bottomAnchor,
                    leading: background.leadingAnchor,
                    trailing: background.trailingAnchor,
                    height: nil,
                    width: nil)
        
        return background
        
    }()
    
    let flipView: UIView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(systemName: "arrow.2.circlepath")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 70).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        view.roundCorners(cornerRadius: 35)
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let background = UIView()
        background.addSubview(view)
        view.anchor(top: background.topAnchor,
                    bottom: background.bottomAnchor,
                    leading: background.leadingAnchor,
                    trailing: background.trailingAnchor,
                    height: nil,
                    width: nil)
        
        return background
        
    }()
    
    let buttonsStackView: UIStackView = {
        
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
        
    }()
    
    var currentCard: TestFlashcard!
    
    let containerView: UIView = {
        
        let view = UIView()
        return view
        
    }()
    
    let keyTypeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Front to Back"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.backgroundColor = .white
        return label
        
    }()
    
    let toggle: UISwitch = {
        
        let toggle = UISwitch()
        toggle.onTintColor = K.Colors.purple
        toggle.addTarget(self, action: #selector(togglePressed(_:)), for: .valueChanged)
        toggle.backgroundColor = .white
        return toggle
        
    }()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        flashcardBackground.setShadow(color: .black, opacity: 0.5, offset: .zero, radius: 3, cornerRadius: 10)
        XView.setShadow(color: .black, opacity: 0.5, offset: .zero, radius: 3, cornerRadius: 30)
        flipView.setShadow(color: .black, opacity: 0.5, offset: .zero, radius: 3, cornerRadius: 30)
        checkmarkView.setShadow(color: .black, opacity: 0.5, offset: .zero, radius: 3, cornerRadius: 30)
        containerView.setShadow(color: .black, opacity: 0.5, offset: .zero, radius: 3)
        containerView.backgroundColor = .white

    }
    
    //MARK: - Setup
    func setup() {
        
        // Get Data
        divisor = (view.frame.width / 2) / 0.61
        myQueue = myDeck.cards.sorted(by: { (card1, card2) -> Bool in
            
            if card1.score <= card2.score { return true }
            else { return false}
            
        })
        
        // Setup Navigation Bar
        centerTitle.text = myDeck.name
        self.navigationItem.titleView = centerTitle
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.Colors.purple
        
        // Configure self.view
        view.backgroundColor = K.Colors.lightGrey
        
        // Add UISwitch and View Type Label
        containerView.addSubview(keyTypeLabel)
        containerView.addSubview(toggle)
        
        keyTypeLabel.anchor(top: containerView.topAnchor,
                            bottom: containerView.bottomAnchor,
                            leading: containerView.leadingAnchor,
                            trailing: toggle.trailingAnchor,
                            height: nil,
                            width: nil,
                            padding: UIEdgeInsets(top: 10, left: 10, bottom: -10, right: 0))
        
        toggle.anchor(top: containerView.topAnchor,
                      bottom: containerView.bottomAnchor,
                      leading: nil,
                      trailing: containerView.trailingAnchor,
                      height: nil,
                      width: nil,
                      padding: UIEdgeInsets(top: 10, left: 0, bottom: -10, right: -10))
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             bottom: nil,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             height: nil,
                             width: nil)
        
        // Add content view
        view.addSubview(contentView)
        view.sendSubviewToBack(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.anchor(top: containerView.bottomAnchor,
                           bottom: nil,
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           height: nil,
                           width: nil)
        
        // Create first card
        createTestFlashcard()
        
        view.addSubview(flashcardBackground)
        flashcardBackground.translatesAutoresizingMaskIntoConstraints = false
        flashcardBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        flashcardBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        flashcardBackground.widthAnchor.constraint(equalToConstant: view.frame.width - 60).isActive = true
        flashcardBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: 350).isActive = true
        
        // Prevent it from becoming to large
        flashcardBackground.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        flashcardBackground.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        flashcardBackground.addSubview(currentCard)
        flashcardBackground.addSubview(imageContainer)
        
        currentCard.anchor(top: flashcardBackground.topAnchor,
                        bottom: flashcardBackground.bottomAnchor,
                        leading: flashcardBackground.leadingAnchor,
                        trailing: flashcardBackground.trailingAnchor,
                        height: nil,
                        width: nil)
        
        imageContainer.anchor(top: flashcardBackground.topAnchor,
                              bottom: flashcardBackground.bottomAnchor,
                              leading: flashcardBackground.leadingAnchor,
                              trailing: flashcardBackground.trailingAnchor,
                              height: nil,
                              width: nil)
        
        imageContainer.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
        
        flashcardBackground.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panCard(_:))))
        flashcardBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))

        
        view.addSubview(buttonsStackView)
        buttonsStackView.anchor(top: contentView.bottomAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                height: nil,
                                width: nil,
                                padding: UIEdgeInsets(top: 0, left: 50, bottom: -20, right: -50))
        
        buttonsStackView.addArrangedSubview(XView)
        buttonsStackView.addArrangedSubview(flipView)
        buttonsStackView.addArrangedSubview(checkmarkView)
        
        XView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(xButtonPressed(_:))))
        flipView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        checkmarkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkButtonPressed(_:))))
        
    }
    
    func createTestFlashcard() {
        
        let flashcard = myQueue[0]
        
        var coloredResults = [ColorResultModel]()
        
        // Populate Results Array
        for (word,wordModel) in zip(flashcard.wordArray, flashcard.wordModelArray) {
            
            // If  Word Model Exists, addg colored word and audio to result
            if let wordModel = wordModel {
                
                // Take only the first ipa spelling for now
                if let ipa = wordModel.ipa[flashcard.ipaIndex] {
                    
                    let audio = (0 < wordModel.audio.count ? wordModel.audio[flashcard.ipaIndex] : nil)
                    var text = WordColoringManager.shared.colorWord(word: wordModel.id, ipa: ipa)
                    text = text.setCapitalLetters(from: word).replaceSpecialCharacters(from: word)
                    coloredResults.append(ColorResultModel(attributedText: text, audioString: audio, ipa: ipa, isColored: true))
                }
            }
        }
        
        let soundItOutColors = self.createButtons(coloredResults[0].attributedText)
        
        self.currentCard = TestFlashcard(frame: .zero,
                                         results: coloredResults,
                                         bottomLabelText: flashcard.bottomLabelText,
                                         soundItOutColors: soundItOutColors)
       
        isFront = isReverse ? false : true
        currentCard.updateSubviewVisibilities(isFront: isFront)
        
    }
    
    func updateTestFlashcard() {
        
        let flashcard = myQueue[0]
        
        var coloredResults = [ColorResultModel]()
        
        // Populate Results Array
        for (word,wordModel) in zip(flashcard.wordArray, flashcard.wordModelArray) {
            
            // If  Word Model Exists, addg colored word and audio to result
            if let wordModel = wordModel {
                
                // Take only the first ipa spelling for now
                if let ipa = wordModel.ipa[flashcard.ipaIndex] {
                    
                    let audio = (0 < wordModel.audio.count ? wordModel.audio[flashcard.ipaIndex] : nil)
                    var text = WordColoringManager.shared.colorWord(word: wordModel.id, ipa: ipa)
                    text = text.setCapitalLetters(from: word).replaceSpecialCharacters(from: word)
                    coloredResults.append(ColorResultModel(attributedText: text, audioString: audio, ipa: ipa, isColored: true))
                }
            }
        }
        
        let soundItOutColors = self.createButtons(coloredResults[0].attributedText)
        
        currentCard.results = coloredResults
        currentCard.bottomLabelText = flashcard.bottomLabelText
        currentCard.soundItOutColors = soundItOutColors
        
        currentCard.updateViews()
        
        isFront = isReverse ? false : true
        currentCard.updateSubviewVisibilities(isFront: isFront)
        
        UIView.animate(withDuration: 0.3) {
            self.flashcardBackground.alpha = 1
            
        }
        
    }
    
    //MARK: - Animations
    
    @objc func panCard(_ sender: UIPanGestureRecognizer) {
                
        let card = sender.view!
        let point = sender.translation(in: view)
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let scale = min(100/abs(point.x), 1)
        
        card.transform = CGAffineTransform(rotationAngle: point.x / divisor).scaledBy(x: scale, y: scale)
        
        if point.x > 0.0 {
            imageView.image = UIImage(systemName: "checkmark")
            imageView.tintColor = K.Colors.green
        } else {
            imageView.image = UIImage(systemName: "xmark")
            imageView.tintColor = K.Colors.red
        }
        
        imageContainer.alpha = abs(point.x) / view.center.x
        
        if sender.state == .ended {
            
            if card.center.x < 75 {
                // Move off to left
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: {(finished: Bool) in
                    self.getNewCard(wasCorrect: false)
                })
                
                return
            }
                
            else if card.center.x > (view.frame.width - 75) {
                // Move off to right
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: {(finished: Bool) in
                    self.getNewCard(wasCorrect: true)
                })
                
                return
            }
            
            resetCard()
        }
    }
    
    func getNewCard(wasCorrect: Bool) {
        
        updateDeckAfterSwipe(wasCorrect)
        flashcardBackground.center = self.view.center
        flashcardBackground.transform = .identity
        self.imageContainer.alpha = 0
            
    }
    
    func resetCard() {
        
        UIView.animate(withDuration: 0.2) {
            self.flashcardBackground.center = self.view.center
            self.imageContainer.alpha = 0
            self.flashcardBackground.alpha = 1
            self.flashcardBackground.transform = .identity
        }
    }
    
    @objc func flipCard(_ sender: UITapGestureRecognizer) {
        
        if isFront {
            
            isFront = false
            currentCard.updateSubviewVisibilities(isFront: isFront)
            UIView.transition(with: self.flashcardBackground, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            
        }
            
        else {
            
            isFront = true
            currentCard.updateSubviewVisibilities(isFront: isFront)
            UIView.transition(with: self.flashcardBackground, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            
        }
    }
    
    @objc func xButtonPressed(_ sender: UITapGestureRecognizer) {
    
        // Move off to left
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            self.flashcardBackground.center = CGPoint(x: self.flashcardBackground.center.x - 300, y: self.flashcardBackground.center.y + 75)
            self.flashcardBackground.alpha = 0
            self.flashcardBackground.transform = CGAffineTransform(rotationAngle: -0.6).scaledBy(x: 0.25, y: 0.25)

        }, completion: {(finished: Bool) in
            self.getNewCard(wasCorrect: false)
        })
        
    }
        
    @objc func checkButtonPressed(_ sender: UITapGestureRecognizer) {
        
        // Move off to right
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            self.flashcardBackground.center = CGPoint(x: self.flashcardBackground.center.x + 300, y: self.flashcardBackground.center.y + 75)
            self.flashcardBackground.alpha = 0
            self.flashcardBackground.transform = CGAffineTransform(rotationAngle: 0.6).scaledBy(x: 0.25, y: 0.25)
        }, completion: {(finished: Bool) in
            self.getNewCard(wasCorrect: true)
        })
        
    }
    
    func updateDeckAfterSwipe(_ wasCorrect: Bool) {
        
        let cardIndex = myQueue[0].cardIndex
        
        if wasCorrect {
            
            // Update Score For Card
            Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].numRight += 1
            Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].numSeen += 1
            
            let numRight = Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].numRight
            let numSeen = Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].numSeen
            
            Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].score =  (Double(numRight) / Double(numSeen)) * 100.0
            
            // Update Score For Deck
            Utilities.shared.user!.decks[myDeckIndex].numRight += 1
            Utilities.shared.user!.decks[myDeckIndex].numSeen += 1

            let deckNumRight = Utilities.shared.user!.decks[myDeckIndex].numRight
            let deckNumSeen = Utilities.shared.user!.decks[myDeckIndex].numSeen

            Utilities.shared.user!.decks[myDeckIndex].prevScore = (Double(deckNumRight) / Double(deckNumSeen)) * 100.0
            
            // Update Firebase
            FirebaseManager.shared.updateUser(user: Utilities.shared.user!)
            
            // Place Card in Back of Queue
            let oldCard = myQueue.remove(at: 0)
            updateTestFlashcard()
            myQueue.append(oldCard)
            
            
        }
        
        else {
            
            // Update Score For Card
            Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].numSeen += 1
            
            let numRight = Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].numRight
            let numSeen = Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].numSeen
            
            Utilities.shared.user!.decks[myDeckIndex].cards[cardIndex].score =  (Double(numRight) / Double(numSeen)) * 100.0
            
            // Update Score For Deck
            Utilities.shared.user!.decks[myDeckIndex].numSeen += 1

            let deckNumRight = Utilities.shared.user!.decks[myDeckIndex].numRight
            let deckNumSeen = Utilities.shared.user!.decks[myDeckIndex].numSeen

            Utilities.shared.user!.decks[myDeckIndex].prevScore = (Double(deckNumRight) / Double(deckNumSeen)) * 100.0
            
            // Update Firebase
            FirebaseManager.shared.updateUser(user: Utilities.shared.user!)
            
            // Place Card 8 cards back or at end if small deck
            let oldCard = myQueue.remove(at: 0)
            updateTestFlashcard()
            
            let randIndex = Int.random(in: 5...10)
            
            if randIndex > myQueue.count - 1 {
                myQueue.append(oldCard)
            }
            
            else {
                myQueue.insert(oldCard, at: randIndex)
            }
            
        }
    
    }
    
    @objc func togglePressed(_ sender: UISwitch) {
        
        if !sender.isOn {
            
            keyTypeLabel.text = "Front to Back"
            isReverse = true
            
            if isFront {
                isFront = false
                currentCard.updateSubviewVisibilities(isFront: isFront)
                UIView.transition(with: self.flashcardBackground, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
            
        }
            
        else {
            
            keyTypeLabel.text = "Back to Front"
            isReverse = false
            
            if !isFront {
                isFront = true
                currentCard.updateSubviewVisibilities(isFront: isFront)
                UIView.transition(with: self.flashcardBackground, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
            
        }
    }
    
}
