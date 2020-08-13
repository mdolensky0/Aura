//
//  DeckSelectingController.swift
//  Aura
//
//  Created by Max Dolensky on 8/9/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class DeckSelectingController: UIViewController {

    // Data
    var bottomLabelText = ""
    var ipaIndex = 0
    var wordArray = [String]()
    var wordModelArray = [WordModel?]()
    
    // SubViews
    let tableView = UITableView()
    
    let newDeckButton: UIButton = {
        
        let button = UIButton()
        
        button.tintColor = .white
        button.backgroundColor = K.Colors.purple
        button.titleLabel?.backgroundColor = K.Colors.purple
        button.setTitleColor(.white, for: .normal)
       
        button.setTitle("NEW DECK", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        
        button.roundCorners(cornerRadius: 20)
        button.addTarget(self, action: #selector(newDeckPressed), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return button
        
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Add to Deck"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
        
    }()
    
    let cancelButton: UIButton = {
        
        let button = UIButton()
        
        button.tintColor = .black
        button.backgroundColor = .clear
        button.titleLabel?.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        
        button.setTitle("cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.titleLabel?.textAlignment = .left

        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        
        view.backgroundColor = .clear

        let container = UIView()
        container.backgroundColor = .white
        container.addSubview(titleLabel)
        container.addSubview(cancelButton)
        container.setUnderlineStyle(color: K.Colors.purple)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        cancelButton.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor).isActive = true
        
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.anchor(top: view.topAnchor,
                         bottom: nil,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         height: 40,
                         width: nil)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeckCell.self, forCellReuseIdentifier: K.Cells.deckCell)

        view.addSubview(tableView)

        tableView.anchor(top: container.bottomAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         height: nil,
                         width: nil)
        
        // Add Header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        headerView.backgroundColor = .white
        
        headerView.addSubview(newDeckButton)
        
        newDeckButton.translatesAutoresizingMaskIntoConstraints = false
        newDeckButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        newDeckButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        tableView.tableHeaderView = headerView
        
        // Add Footer
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        footerView.backgroundColor = .white
        tableView.tableFooterView = footerView
        
    }
    
    @objc func cancelPressed() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func newDeckPressed() {
        
        // Create New Deck
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
    
}


extension DeckSelectingController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Utilities.shared.user?.decks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.deckCell) as! DeckCell
        
        guard let decks = Utilities.shared.user?.decks else { return cell }
        
        cell.nameLabel.text = decks[indexPath.row].name
        cell.numCardsLabel.text = "\(decks[indexPath.row].numberOfCards) cards"

        return cell
    }
    
    
}

extension DeckSelectingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let flashcard = FlashcardModel(wordArray: wordArray,
                                       wordModelArray: wordModelArray,
                                       ipaIndex: ipaIndex,
                                       bottomLabelText: bottomLabelText,
                                       score: -1)
        
        Utilities.shared.user?.decks[indexPath.row].cards.append(flashcard)
        Utilities.shared.user?.decks[indexPath.row].numberOfCards += 1
        
        FirebaseManager.shared.updateUser(user: Utilities.shared.user!)
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
