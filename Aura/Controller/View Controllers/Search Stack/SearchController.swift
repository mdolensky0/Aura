//
//  SearchController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    // Data
    var prevSearches = ["Hello", "Whats up", "Yo dog", "its been so long", "I hope we can hang soon", "you are so amazing", "I am obsessed with you"]
    
    // Main Views and Buttons
    var langStackView = UIStackView()
    var languageButton = UIButton()
    var swapButton = UIButton()
    var textView = UITextView()
    var cancelButton = UIButton()
    var tableView = UITableView()
    
    // Background Views
    let textViewBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = K.Colors.lightGrey
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           
           setupShadows()
       }
}

extension SearchController {
    
//MARK:- View Setup Functions
    
    func setupView() {
        self.setupToHideKeyboardOnTapOnView()
        setupNavBar()
        setupLanguageSelectionView()
        setupTextView()
        setupTableView()
    }
    
    func setupShadows() {
        textViewBackgroundView.setShadow(color: UIColor.black, opacity: 0.3, offset: .init(width: 0, height: 3), radius: 2)
    }
    
    func setupNavBar() {
        
        // Add Center Title
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.backgroundColor = K.Colors.purple
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "Aura"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        self.navigationItem.titleView = label
        
        // Add user button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain,
                                                                 target: self, action: #selector(profileButtonTapped))

        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.Colors.purple
        
    }
    
    func setupLanguageSelectionView() {
        
        // Add Language Bar View
        let langBarView = UIView()
        view.addSubview(langBarView)
        langBarView.backgroundColor = .white
        langBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           bottom: nil,
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           height: 76,
                           width: nil)
        langBarView.setUnderlineStyle(color: K.Colors.purple)
        
        // Add Stack View
        langBarView.addSubview(langStackView)
        langStackView.backgroundColor = .white
        langStackView.anchor(top: langBarView.topAnchor,
                             bottom: langBarView.bottomAnchor,
                             leading: langBarView.leadingAnchor,
                             trailing: langBarView.trailingAnchor,
                             height: nil,
                             width: nil,
                             padding: UIEdgeInsets(top: 0, left: 0, bottom: -2, right: 0))
        langStackView.alignment = .center
        langStackView.distribution = .fillEqually

        // Add Language Button
        languageButton.setTitle("Japanese", for: .normal)
        languageButton.addTarget(self, action: #selector(languageButtonPressed), for: .touchUpInside)
        languageButton.backgroundColor = .white
        languageButton.setTitleColor(UIColor.systemBlue, for: .normal)
        langStackView.addArrangedSubview(languageButton)
        
        // Add Swap Button
        swapButton.setImage(UIImage(systemName: "repeat"), for: .normal)
        swapButton.addTarget(self, action: #selector(swapButtonPressed), for: .touchUpInside)
        swapButton.tintColor = .black
        swapButton.backgroundColor = .white
        langStackView.addArrangedSubview(swapButton)
        
        // Add English Label
        let engLabel = UILabel()
        engLabel.text = "English"
        engLabel.textColor = .black
        engLabel.backgroundColor = .white
        engLabel.textAlignment = .center
        langStackView.addArrangedSubview(engLabel)
        
    }
    
    func setupTextView() {
        
        // Add View
        view.addSubview(textViewBackgroundView)
        textViewBackgroundView.anchor(top: langStackView.bottomAnchor,
                       bottom: nil,
                       leading: view.leadingAnchor,
                       trailing: view.trailingAnchor,
                       height: 160,
                       width: nil,
                       padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
        
        // Add TextView
        textView.delegate = self
        textView.returnKeyType = .search
        view.addSubview(textView)
        textView.anchor(top: textViewBackgroundView.topAnchor,
                        bottom: textViewBackgroundView.bottomAnchor,
                        leading: textViewBackgroundView.leadingAnchor,
                        trailing: textViewBackgroundView.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4))
        textView.text = "Enter text"
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 20)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 50)
        
        // Add X Button
        view.addSubview(cancelButton)
        print(textView.superview!)
        cancelButton.anchor(top: textView.topAnchor,
                            bottom: nil,
                            leading: nil,
                            trailing: textView.trailingAnchor,
                            height: 40,
                            width: 40,
                            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        cancelButton.setImage(UIImage(systemName: "multiply"), for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.tintColor = .black
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelButton.isHidden = true
    }
    
    func setupTableView() {
        
        // TableView Setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PrevSearchCell.self, forCellReuseIdentifier: K.Cells.prevSearchCell)
        tableView.backgroundColor = K.Colors.lightGrey
        
        // Add TableView
        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        tableView.anchor(top: textView.bottomAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
        
        // Add Header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        headerView.backgroundColor = K.Colors.lightGrey
        
        let headerLabel = UILabel()
        headerLabel.backgroundColor = K.Colors.lightGrey
        headerLabel.text = "Previous Searches"
        headerLabel.font = .systemFont(ofSize: 20, weight: .medium)
        headerLabel.textAlignment = .left
        
        headerView.addSubview(headerLabel)
        headerLabel.anchor(top: nil,
                           bottom: headerView.bottomAnchor,
                           leading: headerView.leadingAnchor,
                           trailing: headerView.trailingAnchor,
                           height: nil,
                           width: nil,
                           padding: UIEdgeInsets(top: 10, left: 0, bottom: -20, right: 0))
        tableView.tableHeaderView = headerView
        
        // Add Footer
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        footerView.backgroundColor = K.Colors.lightGrey
        tableView.tableFooterView = footerView
        
        
    }
    
//MARK:- Selector Functions
    
    @objc func profileButtonTapped() {
        print(0)
    }
    
    @objc func languageButtonPressed() {
        print(1)
    }
    
    @objc func swapButtonPressed() {
        print(2)
    }
    
    @objc func cancelButtonPressed() {
        textView.text = ""
        textView.textColor = .lightGray
        textView.text = "Enter text"
        cancelButton.isHidden = true
    }
    
}

//MARK:- UITextView Delegate Methods

extension SearchController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
            cancelButton.isHidden = false
        }
        
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.textColor = .lightGray
            textView.text = "Enter text"
            cancelButton.isHidden = true
        }
        
       
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            print("search")
            // Dismiss Keyboard
            // Perform Search
            return false
        }
        return true
    }

}

//MARK:- UITableView Data Source Methods

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prevSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.prevSearchCell) as! PrevSearchCell
        
        cell.populateCell(topLabelText: prevSearches[indexPath.row], bottomLabelText: prevSearches[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }


}

//MARK:- UITableView Delegate Methods

extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(ResultsController(), animated: true)
    }
}
