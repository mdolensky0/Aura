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
    var prevSearches = ["Hello",
                        "Whats up",
                        "Yo dog",
                        "its been so long",
                        "I hope we can hang soon",
                        "you are so amazing",
                        "I am obsessed with you"]
    
    var bottomLabelText = ""
    var wordArray = [String]()
    var wordModelArray = [WordModel?]()
    var results = [ColorResultModel]()
    var alternateTranslations = [String]()
    var learnMoreArray = [(text: NSMutableAttributedString, ipaIndex: Int)]()
    
    // Search Information
    var searchInfo = SearchInfo(sourceLanguageCode: "en", sourceLanguageName: "English")

    // Main Views and Buttons
    
    var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.backgroundColor = K.Colors.purple
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "Aura"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var languageBarView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.setUnderlineStyle(color: K.Colors.purple)
        return view
        
    }()
    
    var langStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
        
    }()
    
    var languageButton: UIButton = {
        
        let button = UIButton()
        button.addTarget(self, action: #selector(languageButtonPressed), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
        
    }()
    
    var swapButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.addTarget(self, action: #selector(swapButtonPressed), for: .touchUpInside)
        button.tintColor = .black
        button.backgroundColor = .white
        return button
        
    }()
    
    var englishLabel: UILabel = {
        
        let label = UILabel()
        label.text = "English HD"
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var textView: UITextView = {
        
        let textView = UITextView()
        textView.returnKeyType = .search
        textView.text = "Enter text"
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 20)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 50)
        return textView
    
    }()
    
    var cancelButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.isHidden = true
        return button
        
    }()
    
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
        textViewBackgroundView.setShadowWithBZPath(color: UIColor.black, opacity: 0.3, offset: .init(width: 0, height: 3), radius: 2)
    }
    
    func setupNavBar() {
        
        // Add Center Title
        self.navigationItem.titleView = titleLabel
        
        // Add user button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain,
                                                                 target: self, action: #selector(profileButtonTapped))

        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.Colors.purple
        
    }
    
    func setupLanguageSelectionView() {
        
        // Add Language Bar View
        view.addSubview(languageBarView)
        languageBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           bottom: nil,
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           height: 76,
                           width: nil)
        
        // Add Stack View
        languageBarView.addSubview(langStackView)
        langStackView.anchor(top: languageBarView.topAnchor,
                             bottom: languageBarView.bottomAnchor,
                             leading: languageBarView.leadingAnchor,
                             trailing: languageBarView.trailingAnchor,
                             height: nil,
                             width: nil,
                             padding: UIEdgeInsets(top: 0, left: 0, bottom: -2, right: 0))

        // Add Language Button
        langStackView.addArrangedSubview(languageButton)
        setupLangButtonWithDeviceLang()
        
        // Add Swap Button
        langStackView.addArrangedSubview(swapButton)
        
        // Add English Label
        langStackView.addArrangedSubview(englishLabel)
        
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
        view.addSubview(textView)
        textView.anchor(top: textViewBackgroundView.topAnchor,
                        bottom: textViewBackgroundView.bottomAnchor,
                        leading: textViewBackgroundView.leadingAnchor,
                        trailing: textViewBackgroundView.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4))
       
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
        
        let supportedLanguagesVC = SupportedLanguagesVC()
        supportedLanguagesVC.delegate = self
        self.present(supportedLanguagesVC, animated: true, completion: nil)
        
    }
    
    @objc func swapButtonPressed() {
        
        DispatchQueue.main.async {
            
            // Retrieve Subviews
            let subviews = self.langStackView.arrangedSubviews
            
            let sub0 = subviews[0]
            let sub1 = subviews[1]
            let sub2 = subviews[2]
            
            // Change Search Type and If Necessary, Change English HD to English
            switch self.searchInfo.searchType {
            
            case .englishToNative:
                self.searchInfo.searchType = .nativeToEnglish
                
            case .nativeToEnglish:
                self.searchInfo.searchType = .englishToNative

            }
            
            // Clear Subviews
            for subview in self.langStackView.arrangedSubviews {
                self.langStackView.removeArrangedSubview(subview)
            }
            
            // Add Subviews Flipped
            self.langStackView.addArrangedSubview(sub2)
            self.langStackView.addArrangedSubview(sub1)
            self.langStackView.addArrangedSubview(sub0)
            
        }
        
        // Swap Source And Target Language Codes and Names
        let tempSourceCode = searchInfo.sourceLanguageCode
        searchInfo.sourceLanguageCode = searchInfo.targetLanguageCode
        searchInfo.targetLanguageCode = tempSourceCode
        
        let tempSourceName = searchInfo.sourceLanguageName
        searchInfo.sourceLanguageName = searchInfo.targetLanguageName
        searchInfo.targetLanguageName = tempSourceName
        
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
            
            // Make sure textView is not Empty
            if textView.text != nil && textView.text.count > 0 {
                
                textView.resignFirstResponder()
                
                startSearchSequence(searchText: textView.text!, searchInfo)
                
            }
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
        
    }
    
}

//MARK:- Language Selection Functions

extension SearchController: SupportedLanguagesDelegate, ResultsControllerDelegate {
    
    func updateLanguageStackView(searchInfo: SearchInfo) {
        
        self.searchInfo = searchInfo
        
        DispatchQueue.main.async {
            
            for view in self.langStackView.arrangedSubviews {
                self.langStackView.removeArrangedSubview(view)
            }
            
            switch self.searchInfo.searchType {
            
            case .englishToNative:
                self.langStackView.addArrangedSubview(self.englishLabel)
                self.englishLabel.text = "English HD"
                
                self.langStackView.addArrangedSubview(self.swapButton)
                
                self.langStackView.addArrangedSubview(self.languageButton)
                self.languageButton.setTitle(self.searchInfo.targetLanguageName, for: .normal)
                
            case .nativeToEnglish:
                self.langStackView.addArrangedSubview(self.languageButton)
                self.languageButton.setTitle(self.searchInfo.sourceLanguageName, for: .normal)
                
                self.langStackView.addArrangedSubview(self.swapButton)
                
                self.langStackView.addArrangedSubview(self.englishLabel)
                self.englishLabel.text = "English HD"
            }
            
        }
    }
    
    func updateLanguageCodes(languageName: String, languageCode: String) {
        
        switch searchInfo.searchType {
            
        case .englishToNative:
            searchInfo.targetLanguageCode = languageCode
            searchInfo.targetLanguageName = languageName
            
        case .nativeToEnglish:
            searchInfo.sourceLanguageCode = languageCode
            searchInfo.sourceLanguageName = languageName
            
        }
        
        languageButton.setTitle(languageName, for: .normal)
    }
    
    func setupLangButtonWithDeviceLang() {
        
        var buttonLanguageCode = getDeviceLanguageCode()
        let buttonLanguageName = K.LanguageCodes.languageDict[buttonLanguageCode]
        
        if let code = K.LanguageCodes.iosToGoogleLangCode[buttonLanguageCode] {
            
            buttonLanguageCode = code
            
        }
        
        languageButton.setTitle(buttonLanguageName, for: .normal)
        
        self.searchInfo.sourceLanguageCode = buttonLanguageCode
        
        if let name = buttonLanguageName {
            self.searchInfo.sourceLanguageName = name
        }
    }
    
}

// MARK:- Search Sequence Functions

extension SearchController {
    
    func startSearchSequence(searchText: String,_ searchInfo: SearchInfo, ipaIndex: Int = 0) {
        
        //Update global SearchInfo
        self.searchInfo = searchInfo
        
        // Set Language Codes
        TranslationManager.shared.sourceLanguageCode = searchInfo.sourceLanguageCode
        TranslationManager.shared.targetLanguageCode = searchInfo.targetLanguageCode
        
        // Clear Results Array
        results = []
        wordArray = []
        bottomLabelText = ""
        wordModelArray = []
        alternateTranslations = []
        
        // Update Query Text
        bottomLabelText = searchText
        
        // Start Loading Screen
        DispatchQueue.main.async {
            self.startLoadingScreen()
        }
        
        // translate and populate wordModelArray and alternatives array, then color words
        runSearchsequence(searchText: searchText) { (success) in
            
            if success {
                
                // Populate Results Array
                for (word,wordModel) in zip(self.wordArray, self.wordModelArray) {
                    
                    // If  Word Model Exists, addg colored word and audio to result
                    if let wordModel = wordModel {
                        
                        // Take only the first ipa spelling for now
                        if let ipa = wordModel.ipa[ipaIndex] {
                            
                            let audio = (0 < wordModel.audio.count ? wordModel.audio[ipaIndex] : nil)
                            var text = WordColoringManager.shared.colorWord(word: wordModel.id, ipa: ipa)
                            text = text.setCapitalLetters(from: word).replaceSpecialCharacters(from: word)
                            self.results.append(ColorResultModel(attributedText: text, audioString: audio, ipa: ipa, isColored: true))
                        }
                        
                        for i in 0..<wordModel.ipa.count {
                            
                            if let ipa = wordModel.ipa[i] {
                                
                                var text = WordColoringManager.shared.colorWord(word: wordModel.id, ipa: ipa)
                                text = text.setCapitalLetters(from: word).replaceSpecialCharacters(from: word)
                                self.learnMoreArray.append((text: text, ipaIndex: i))
                            }
                            
                        }
                        
                    }
                        
                        // If Word Model doesn't exist, add plain text to result
                    else {
                        
                        let text = NSMutableAttributedString(string: word)
                        self.results.append(ColorResultModel(attributedText: text, audioString: nil, ipa: "", isColored: false))
                        self.learnMoreArray.append((text: text, ipaIndex: 0))
                    }
                }
                
                // End Loading Screen
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                    self.goToResultsVC(searchInfo: searchInfo)
                }
            }
                
                // If search sequence not successful (no words found in database) alert to check spelling and internet
            else {
                
                for word in self.wordArray {
                    
                    self.results.append(ColorResultModel(attributedText: NSMutableAttributedString(string: word),
                                                         audioString: nil, ipa: "", isColored: false))
                    
                }
                
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                    self.goToResultsVC(searchInfo: searchInfo)
                }
            }
        }
        
    }
    
    func runSearchsequence(searchText: String, completion: @escaping(_ success: Bool) -> Void) {
        
        switch searchInfo.searchType {
        
        case .nativeToEnglish:
            
            // If source Lang is English, retrieve word models from database
            if TranslationManager.shared.sourceLanguageCode == "en" {
                
                self.wordArray = searchText.replacingOccurrences(of: "’", with: "'").split(separator: " ").map {String($0)}
               
                FirebaseManager.shared.readEnglishDocumentByWord(words: wordArray) { (wordModelArray) in
                    
                    self.wordModelArray = wordModelArray
                    
                    let filteredArray = wordModelArray.filter { $0 != nil }
                    if wordModelArray.count > 0 && filteredArray.count > 0 {
                        completion(true)
                    } else {completion(false)}
                }
            }
                
            // Otherwise get translations and then retrieve word models from database
            else {
                
                TranslationManager.shared.textToTranslate = searchText
                TranslationManager.shared.translate { (translation) in
                    
                    guard let translation = translation else {
                        print("Translation is nil")
                        completion(false)
                        return
                    }
                    
                    if translation.count > 1 {
                        self.alternateTranslations = translation[1..<translation.count].map { String($0) }
                    }
                    
                    self.wordArray = translation[0].split(separator: " ").map { String($0) }
                    
                    FirebaseManager.shared.readEnglishDocumentByWord(words: self.wordArray) { (wordModelArray) in
                        
                        self.wordModelArray = wordModelArray
                        
                        let filteredArray = wordModelArray.filter { $0 != nil }
                        if wordModelArray.count > 0 && filteredArray.count > 0 {
                            self.linkNativeToEnglish(self.wordModelArray)
                            completion(true)
                        } else {completion(false)}
                    }
                }
            }

        case .englishToNative:
            
            // If Target Lang is English, retrieve word models from database
            if TranslationManager.shared.targetLanguageCode == "en" {
                
                self.wordArray = searchText.replacingOccurrences(of: "’", with: "'").split(separator: " ").map {String($0)}
               
                FirebaseManager.shared.readEnglishDocumentByWord(words: wordArray) { (wordModelArray) in
                    
                    self.wordModelArray = wordModelArray
                    
                    let filteredArray = wordModelArray.filter { $0 != nil }
                    if wordModelArray.count > 0 && filteredArray.count > 0 {
                        completion(true)
                    } else {completion(false)}
                }
            }
            
            // Otherwise get translations and then retrieve word models from database
            else {
                
                TranslationManager.shared.textToTranslate = searchText
                TranslationManager.shared.translate { (translation) in
                    
                    guard let translation = translation else {
                        print("Translation is nil")
                        completion(false)
                        return
                    }
                    
                    if translation.count > 1 {
                        self.alternateTranslations = translation[1..<translation.count].map { String($0) }
                    }
                    
                    self.bottomLabelText = translation[0]
                    
                    self.wordArray = searchText.split(separator: " ").map { String($0) }
                    
                    FirebaseManager.shared.readEnglishDocumentByWord(words: self.wordArray) { (wordModelArray) in
                        
                        self.wordModelArray = wordModelArray
                        
                        let filteredArray = wordModelArray.filter { $0 != nil }
                        if wordModelArray.count > 0 && filteredArray.count > 0 {
                            self.linkNativeToEnglish(self.wordModelArray)
                            completion(true)
                        } else {completion(false)}
                    }
                }
            }
        }
    }
    
    func linkNativeToEnglish(_ wordModelArray: [WordModel?]) {
        if let searchedText = TranslationManager.shared.textToTranslate, let sourceLang = TranslationManager.shared.sourceLanguageCode {
            var englishIDArray = [Int]()
            for model in wordModelArray {
                if let model = model {
                    englishIDArray.append(model.number)
                } else { englishIDArray.append(-1)} // -1 means missing english word
            }
            let newTranslationModel = TranslationModel(nativeText: searchedText, wordModelIDs: englishIDArray)
            FirebaseManager.shared.writeNativeWordData(translationModel: newTranslationModel, to: sourceLang)
        }
    }
    
    func goToResultsVC(searchInfo: SearchInfo) {
        
        let resultsController = ResultsController()
        
        resultsController.delegate = self
        resultsController.searchInfo = searchInfo
        resultsController.bottomLabelText = self.bottomLabelText
        resultsController.wordArray = self.wordArray
        resultsController.wordModelArray = self.wordModelArray
        resultsController.results = self.results
        resultsController.alternateTranslations = self.alternateTranslations
        resultsController.learnMoreArray = self.learnMoreArray
        
        if results.count == 1 {
            
            resultsController.soundItOutColors = self.createButtons(results[0].attributedText)
        
        } else { resultsController.soundItOutColors = [] }
            
        navigationController?.pushViewController(resultsController, animated: true)
        
    }
}
