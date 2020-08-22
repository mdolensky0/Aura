//
//  DeckController.swift
//  Aura
//
//  Created by Max Dolensky on 8/5/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import SwipeCellKit

class DeckController: UIViewController {

    //MARK: - Data
    var myDeck: DeckModel!
    var myDeckIndex: Int!
    var scrollViewHeight: NSLayoutConstraint!
    var heightArray = [CGFloat]()
    var currentCardIndex = 0
    
    //MARK: - Subviews
    var centerTitle: UILabel = {
       
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        label.backgroundColor = .clear
        label.font = UIFont(name: K.Fonts.avenirBlack, size: 17)
        label.text = "Deck Name"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var mainScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
        
    }()
        
    var mainStackView: UIStackView = {
       
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        return stackView
        
    }()
    
    var flashcardsScrollView: FlashcardsScrollView?
    
    var testYourselfBackground: UIView = {
        
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return background
        
    }()
    
    var testYourselfButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Test Yourself", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(takeTest(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(cancelEvent(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(cancelEvent(_:)), for: .touchDragOutside)
        button.addTarget(self, action: #selector(touchDown(_:)), for: .touchDragInside)
        button.roundCorners(cornerRadius: 10)
        return button
        
    }()
    
    let statsLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        label.roundCorners(cornerRadius: 10)
        return label
        
    }()
    
    var statsLabelBackground: UIView = {
        
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return background
        
    }()
    
    var noFlashcardsLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .center
        label.textColor = K.Colors.darkGrey
        label.text = "There are no flashcards in the deck yet.\n\nTo add flashcards search a word and then press the + icon"
        return label
    
    }()
        
    let tableView = NoScrollTableView()
    
    //MARK: - VC LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

    }
    
    override func viewDidLayoutSubviews() {
        
        testYourselfBackground.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 4, height: 4), radius: 3, cornerRadius: 10)
        
        testYourselfButton.setGradientBackground(topColor: UIColor(red: 248.0/255.0, green: 231.0/255.0, blue: 0.0, alpha: 1.0),
                                                 bottomColor: UIColor(red: 249.0/255.0, green: 150.0/255.0, blue: 0.0, alpha: 1.0),
                                                 cornerRadius: 10)
        
        for card in flashcardsScrollView!.stackView.subviews {
            card.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 4, height: 4), radius: 3, cornerRadius: 10)
        }
        
        for view in flashcardsScrollView!.flashcards {
        
            view.addFlashcardBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 30)
            
            view.soundBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 21)
            
            view.loopBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 21)
        }
        
        statsLabelBackground.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 4, height: 4), radius: 3, cornerRadius: 10)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.updateFlashcardScrollView()
        self.updateVisibilities()
        self.testYourselfButton.setGradientBackground(topColor: UIColor(red: 248.0/255.0, green: 231.0/255.0, blue: 0.0, alpha: 1.0),
                                                      bottomColor: UIColor(red: 249.0/255.0, green: 150.0/255.0, blue: 0.0, alpha: 1.0),
                                                      cornerRadius: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.scrollViewHeight.isActive = false
        self.view.layoutIfNeeded()
        
        heightArray = []
        
        for card in self.flashcardsScrollView!.stackView.subviews {
            self.heightArray.append(card.frame.height)
        }
        
        if myDeck.cards.count > 0 {
            
            self.scrollViewHeight.constant = self.heightArray[self.currentCardIndex]
            self.scrollViewHeight.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    //MARK: - Setup
    func setup() {
        
        view.backgroundColor = K.DesignColors.background
        
        // Setup Navigation Bar
        centerTitle.text = myDeck.name
        self.navigationItem.titleView = centerTitle
        
        // Add UserButton and Trash Button
        let userButton = UIBarButtonItem(image: UIImage(systemName: "person"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(profileButtonTapped))
        
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(trashButtonPressed))
        
        self.navigationItem.rightBarButtonItems = [trashButton, userButton]
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.DesignColors.primary
        
        // Add scroll view and Content view
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
        
        
        let flashcards = makeResultCardViews()
        
        for card in flashcards {

            card.translatesAutoresizingMaskIntoConstraints = false
            card.widthAnchor.constraint(equalToConstant: view.frame.width - 60).isActive = true

        }
                
        flashcardsScrollView = FlashcardsScrollView(frame: .zero, flashcards: flashcards)
        scrollViewHeight = flashcardsScrollView?.heightAnchor.constraint(equalToConstant: 0)
        flashcardsScrollView?.delegate = self
                
        mainStackView.addArrangedSubview(flashcardsScrollView!)
        
        // Constrain Scroll View width so that the prev and next cards show on the screen and the main stackView can adjust its size
        flashcardsScrollView?.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
        // Add Test Yourself Button
        testYourselfBackground.addSubview(testYourselfButton)
        
        testYourselfButton.anchor(top: testYourselfBackground.topAnchor,
                                  bottom: testYourselfBackground.bottomAnchor,
                                  leading: testYourselfBackground.leadingAnchor,
                                  trailing: testYourselfBackground.trailingAnchor,
                                  height: nil,
                                  width: nil)
        
        testYourselfBackground.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
        
        mainStackView.addArrangedSubview(testYourselfBackground)
                
        // Add Stats Label
        updateStatsLabel()
        
        statsLabelBackground.addSubview(statsLabel)
        
        statsLabel.anchor(top: statsLabelBackground.topAnchor,
                          bottom: statsLabelBackground.bottomAnchor,
                          leading: statsLabelBackground.leadingAnchor,
                          trailing: statsLabelBackground.trailingAnchor,
                          height: nil,
                          width: nil)
        
        statsLabelBackground.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
        mainStackView.addArrangedSubview(statsLabelBackground)
                
        // Setup Flashcard Detail Views
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70.0;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.register(FlashcardCell.self, forCellReuseIdentifier: K.Cells.flashcardCell)
        tableView.backgroundColor = .clear
        
        mainStackView.addArrangedSubview(tableView)
        tableView.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
        
        // Add Header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        headerView.backgroundColor = .clear
        
        let headerLabel = UILabel()
        headerLabel.backgroundColor = .clear
        headerLabel.text = "Cards"
        headerLabel.font = .systemFont(ofSize: 17, weight: .regular)
        headerLabel.textAlignment = .left
        
        headerView.addSubview(headerLabel)
        headerLabel.anchor(top: nil,
                           bottom: headerView.bottomAnchor,
                           leading: headerView.leadingAnchor,
                           trailing: headerView.trailingAnchor,
                           height: nil,
                           width: nil,
                           padding: UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0))
        tableView.tableHeaderView = headerView
        
        // Add Footer
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        footerView.backgroundColor = .clear
        tableView.tableFooterView = footerView
        
        // Add No Cards Label
        noFlashcardsLabel.translatesAutoresizingMaskIntoConstraints = false
        noFlashcardsLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
        mainStackView.addArrangedSubview(noFlashcardsLabel)
        
        updateVisibilities()
    }
    
    func updateVisibilities() {
        
        DispatchQueue.main.async {
            
            self.myDeck = Utilities.shared.user?.decks[self.myDeckIndex]
            
            if self.myDeck.cards.count == 0 {
                
                self.flashcardsScrollView?.isHidden = true
                self.testYourselfBackground.isHidden = true
                self.statsLabel.isHidden = true
                self.tableView.isHidden = true
                self.noFlashcardsLabel.isHidden = false
                
            }
            
            else {
                
                self.flashcardsScrollView?.isHidden = false
                self.testYourselfBackground.isHidden = false
                self.statsLabel.isHidden = false
                self.tableView.isHidden = false
                self.noFlashcardsLabel.isHidden = true
                self.tableView.reloadData()
                self.updateStatsLabel()
            }
            
        }
    }
    
    func updateStatsLabel() {
        
        var formatted = NSMutableAttributedString(string: String(format: "%.1f", myDeck.prevScore))
        formatted.append(NSAttributedString(string: "%"))
        
        if myDeck.prevScore < 0 {
            
            formatted = NSMutableAttributedString(string: "-%")
            
        }
        
        else if myDeck.prevScore >= 0 && myDeck.prevScore <= 50 {
            
            formatted.addAttribute(.foregroundColor, value: K.Colors.red, range: NSRange(location: 0, length: formatted.length))
            
        }
        
        else if myDeck.prevScore > 50  && myDeck.prevScore <= 69 {
            
            formatted.addAttribute(.foregroundColor, value: K.Colors.orange, range: NSRange(location: 0, length: formatted.length))
            
        }
        
        else if myDeck.prevScore > 69 && myDeck.prevScore <= 79 {
            
            formatted.addAttribute(.foregroundColor, value: K.Colors.yellow, range: NSRange(location: 0, length: formatted.length))
            
        }
        
        else if myDeck.prevScore > 79 && myDeck.prevScore <= 100 {
            
            formatted.addAttribute(.foregroundColor, value: K.Colors.green, range: NSRange(location: 0, length: formatted.length))
            
        }
        
        let attText = NSMutableAttributedString(string: "  \(myDeck.numberOfCards) Cards\n  Score: ")
        attText.append(formatted)
        
        statsLabel.attributedText = attText
        
    }
        
    func makeResultCardViews() -> [ResultCardView] {
        
        var result = [ResultCardView]()
        
        for flashcard in myDeck.cards {
            
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
            
            let card = ResultCardView(frame: .zero,
                                      results: coloredResults,
                                      bottomLabelText: flashcard.bottomLabelText,
                                      soundItOutColors: soundItOutColors,
                                      isFlashcard: true)
            result.append(card)
            
        }
        
        return result
    }
    
    func updateFlashcardScrollView(didDelete: Bool = false) {
    
        DispatchQueue.main.async {
            
            self.myDeck = Utilities.shared.user?.decks[self.myDeckIndex]
            
            let flashcards = self.makeResultCardViews()
            
            for card in flashcards {
                
                card.translatesAutoresizingMaskIntoConstraints = false
                card.widthAnchor.constraint(equalToConstant: self.view.frame.width - 60).isActive = true
                
            }
                        
            self.flashcardsScrollView!.updateFlashcards(flashcards) {
                
                for card in self.flashcardsScrollView!.stackView.subviews {
                    card.setShadow(color: .black, opacity: 0.5, offset: .zero, radius: 2, cornerRadius: 10)
                }
                
                if didDelete {
                    
                    if self.myDeck.cards.count > 0 {
                        
                        self.scrollViewHeight.constant = self.heightArray[self.currentCardIndex]
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                        
                    }
                }
            }
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
    
    @objc func trashButtonPressed() {
        
        let alert = UIAlertController(title: "Delete Deck", message: "Are you sure you want to delete this entire deck?", preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            if var user = Utilities.shared.user {
                
                user.decks.remove(at: self.myDeckIndex)
                FirebaseManager.shared.updateUser(user: user)
                self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            return
        }
        
        alert.addAction(actionOK)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func takeTest(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.3
        }
        
        let vc = TestController()
        vc.myDeck = self.myDeck
        vc.myDeckIndex = self.myDeckIndex
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func touchDown(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.superview?.layer.shadowOpacity = 0.5
        }
    }
    
    @objc func cancelEvent(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.3
        }
        
    }
    
}

//MARK: - TableView Data Source Method
extension DeckController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDeck.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.flashcardCell) as! FlashcardCell
        cell.delegate = self
        
        let card = myDeck.cards[indexPath.row]
        
        // Set top label text
        let wordArray = card.wordArray
        var topText = ""
        
        for i in 0..<wordArray.count {
            
            topText.append(wordArray[i])
            
            if i != wordArray.count - 1 {
                topText.append(" ")
            }
        }
        
        cell.topLabel.text = topText
        
        // Set bottom label text
        cell.bottomLabel.text = card.bottomLabelText
        
        // Set score
        var formatted = NSMutableAttributedString(string: String(format: "%.1f", card.score))
        formatted.append(NSAttributedString(string: "%"))
        
        if card.score < 0 {
            
            formatted = NSMutableAttributedString(string: "-%")
            
        }
        
        else if card.score >= 0 && card.score <= 50 {
            
            formatted.addAttribute(.foregroundColor, value: K.Colors.red, range: NSRange(location: 0, length: formatted.length))
            
        }
        
        else if card.score > 50  && card.score <= 69 {
            
            formatted.addAttribute(.foregroundColor, value: K.Colors.orange, range: NSRange(location: 0, length: formatted.length))
            
        }
        
        else if card.score > 69 && card.score <= 79 {
            
            formatted.addAttribute(.foregroundColor, value: K.Colors.yellow, range: NSRange(location: 0, length: formatted.length))
            
        }
        
        else if card.score > 79 && card.score <= 100 {
            
            formatted.addAttribute(.foregroundColor, value: K.Colors.green, range: NSRange(location: 0, length: formatted.length))
            
        }
        
        cell.scoreLabel.attributedText = formatted
        cell.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        return cell
    }
    
    
}

//MARK: - TableView Delegate Methods
extension DeckController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        mainScrollView.setContentOffset(.zero, animated: true)
        
        flashcardsScrollView?.setContentOffset( CGPoint(x: flashcardsScrollView!.frame.size.width * CGFloat(indexPath.row), y: 0.0), animated: true)
        
        currentCardIndex = indexPath.row
        scrollViewHeight.constant = heightArray[currentCardIndex]
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}

//MARK: -  Swipe Delegate Methods
extension DeckController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                // Update Current Card Index
                self.currentCardIndex = (self.currentCardIndex == self.myDeck.cards.count - 1) ? (self.currentCardIndex - 1): self.currentCardIndex
                self.heightArray.remove(at: indexPath.row)
                
                // handle action by updating model with deletion
                self.myDeck.cards.remove(at: indexPath.row)
                self.myDeck.numberOfCards -= 1
                
                // Decrease each card index after the deleted card by one
                for i in indexPath.row..<self.myDeck.cards.count {
                    self.myDeck.cards[i].cardIndex -= 1
                }
                
                if var user = Utilities.shared.user {
                    
                    user.decks[self.myDeckIndex] = self.myDeck
                    FirebaseManager.shared.updateUser(user: user)
                    self.updateStatsLabel()
                    self.updateFlashcardScrollView(didDelete: true)
                    
                }
                self.updateVisibilities()
            }
        
            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

}

//MARK: - Scroll View Delegate

extension DeckController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        currentCardIndex = Int(targetContentOffset.pointee.x / flashcardsScrollView!.frame.size.width)
        
        scrollViewHeight.constant = heightArray[currentCardIndex]
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}
