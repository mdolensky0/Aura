//
//  LearnMoreController.swift
//  Aura
//
//  Created by Max Dolensky on 8/21/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import AVFoundation
import AMPopTip

class LearnMoreController: UIViewController {
    
    //MARK: - Data
    
    var bottomLabelText = ""
    var searchInput = ""
    var searchOutput = ""
    var ipaIndex = 0
    var wordArray = [String]()
    var wordModelArray = [WordModel?]()
    var results = [ColorResultModel]()
    var soundItOutColors = [(color: UIColor, ID: String, range: NSRange)]()
    var alternateTranslations = [String]()
    var learnMoreArray = [(text: NSMutableAttributedString, ipaIndex: Int)]()
    var isFullyMatched = true
    var searchStatus: SearchStatus!
    
    // Search Information
    var searchInfo = SearchInfo(sourceLanguageCode: "en", sourceLanguageName: "English")
    
    //MARK: - Utilities
    
    let cellID = "SoundItOutCell"
    
    //MARK: - Views
    
    var centerTitle: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        label.backgroundColor = .clear
        label.font = UIFont(name: K.Fonts.avenirBlack, size: 17)
        label.text = "Aura"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var mainScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = K.DesignColors.background
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
    
    var searchStatusView = SearchStatusView()
    
    var resultCard = ResultCardView()
    
    var alternativesScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.masksToBounds = false
        return scrollView
        
    }()
    
    var alternativesContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }()
    
    var alternativesStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.masksToBounds = false
        return stackView
        
    }()
    
    var alternativesHeaderLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Alternative Translations"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        return label
        
    }()
    
    var learnMoreScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.masksToBounds = false
        return scrollView
        
    }()
    
    var learnMoreContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }()
    
    var learnMoreStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.layer.masksToBounds = false
        return stackView
        
    }()
    
    var learnMoreHeaderLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Learn More"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        return label
        
    }()
    
    var goToFlashcardsButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Study Flashcards", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        button.tintColor = .white
        button.setBackgroundImage(#imageLiteral(resourceName: "study"), for: .normal)
        button.addTarget(self, action: #selector(goToFlashcardButtonPressed(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(cancelEvent(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(cancelEvent(_:)), for: .touchDragOutside)
        button.addTarget(self, action: #selector(touchDown(_:)), for: .touchDragInside)
        button.roundCorners(cornerRadius: 10)
        return button
        
    }()
    
    var lessonsButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Lessons", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        button.tintColor = .white
        button.setBackgroundImage(#imageLiteral(resourceName: "classroom"), for: .normal)
        button.addTarget(self, action: #selector(goToLessonButtonPressed(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(cancelEvent(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(cancelEvent(_:)), for: .touchDragOutside)
        button.addTarget(self, action: #selector(touchDown(_:)), for: .touchDragInside)
        button.roundCorners(cornerRadius: 10)
        return button
        
    }()
    
    // Background Views
    let resultBackgroundView = UIView ()
    
    let goToFlashcardBackgroundView = UIView()
    
    let lessonBackgroundView = UIView()
    
    //MARK: - Class Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.DesignColors.background
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if searchStatus != .success {
            
            searchStatusView.setLabelText(status: searchStatus)
            searchStatusView.superview?.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        else if !self.isFullyMatched {
            
            self.searchStatusView.setLabelTextAsColorErr()
            self.searchStatusView.superview?.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupShadows()
    }
}

extension LearnMoreController {
    
    //MARK:- View Setup Functions
    
    func setupView() {
        self.setupToHideKeyboardOnTapOnView()
        setupNavBar()
        setupScrollView()
    }
    
    func setupShadows() {
        
        searchStatusView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
        resultBackgroundView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
        resultCard.addFlashcardBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 30)
        
        resultCard.soundBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 21)
        
        resultCard.loopBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 21)
        
        for view in alternativesStackView.arrangedSubviews {
            view.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
        for view in learnMoreStackView.arrangedSubviews {
            view.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
        goToFlashcardBackgroundView.setShadow(color: .black, opacity: 0.7, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        
        lessonBackgroundView.setShadow(color: .black, opacity: 0.7, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        
    }
    
    func setupNavBar() {
        
        // Add Center Title
        self.navigationItem.titleView = centerTitle
        self.navigationController?.navigationBar.topItem?.title = " "
        
        // Add userbutton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(profileButtonTapped))
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.DesignColors.primary
        
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
        
        // Setup Results Card
        resultCard = ResultCardView(frame: .zero,
                                    results: self.results,
                                    bottomLabelText: self.bottomLabelText,
                                    soundItOutColors: self.soundItOutColors,
                                    delegate: self)
        
        resultBackgroundView.addSubview(resultCard)
        
        resultCard.anchor(top: resultBackgroundView.topAnchor,
                          bottom: resultBackgroundView.bottomAnchor,
                          leading: resultBackgroundView.leadingAnchor,
                          trailing: resultBackgroundView.trailingAnchor,
                          height: nil,
                          width: nil)
        
        // Add Search Status View to Stack View
        mainStackView.addArrangedSubview(searchStatusView, withMargin: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        searchStatusView.superview?.isHidden = true
        
        // Add Results Card to Stack View
        mainStackView.addArrangedSubview(resultBackgroundView, withMargin: UIEdgeInsets(top: 27, left: 20, bottom: 0, right: -20))
        
        // Setup Alternative Translations Scroll View
        setupAlternativeTranslationScrollView()
        
        // Setup Learn More Scroll View
        setupLearnMoreScrollView()
        
        // Setup FlashCard UpSaleButton
        setupGoToFlashcardsButton()
        
        // Setup Lessons UpSaleButton
        setupLessonsButton()
        
    }
    
    func setupAlternativeTranslationScrollView() {
        
        // Add Header Label and Scroll View to the Main Content View
        mainStackView.addArrangedSubview(alternativesHeaderLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        mainStackView.addArrangedSubview(alternativesScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        // Add Stack View to Scroll View
        alternativesScrollView.addSubview(alternativesStackView)
        
        // Anchor StackView Within Scroll View
        alternativesStackView.anchor(top: alternativesScrollView.topAnchor,
                                     bottom: alternativesScrollView.bottomAnchor,
                                     leading: alternativesScrollView.leadingAnchor,
                                     trailing: alternativesScrollView.trailingAnchor,
                                     height: nil,
                                     width: nil)
        
        // Prevent Vertical Scrolling
        alternativesStackView.heightAnchor.constraint(equalTo: alternativesScrollView.heightAnchor).isActive = true
        
        
        // Populate Alternative Translations Stack View
        populateAlternativeTranslationsStackView()
        
    }
    
    func populateAlternativeTranslationsStackView() {
        
        if alternateTranslations.count == 0 {
            
            alternativesHeaderLabel.superview?.isHidden = true
            alternativesScrollView.superview?.isHidden = true
            
        }
            
        else {
            
            alternativesHeaderLabel.superview?.isHidden = false
            alternativesScrollView.superview?.isHidden = false
            
        }
        
        for alt in alternateTranslations {
            
            // Create Background Shadow View
            let myView = UIView()
            alternativesStackView.addArrangedSubview(myView)
            myView.widthAnchor.constraint(equalToConstant: 220).isActive = true
            myView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            // Create Content View
            let myContentView = UIView()
            myContentView.backgroundColor = .white
            myContentView.roundCorners(cornerRadius: 10)
            myView.addSubview(myContentView)
            myContentView.anchor(top: myView.topAnchor,
                                 bottom: myView.bottomAnchor,
                                 leading: myView.leadingAnchor,
                                 trailing: myView.trailingAnchor,
                                 height: nil,
                                 width: nil)
            
            // Formate Atrributed Text
            let attText = NSMutableAttributedString(string: alt)
            attText.addAttribute(.font, value: UIFont.systemFont(ofSize: 30), range: NSRange(location: 0, length: attText.length))
            
            // Create Label
            let myLabel = UILabel()
            myLabel.attributedText = attText
            myLabel.numberOfLines = 2
            myLabel.backgroundColor = .white
            myLabel.textAlignment = .left
            myContentView.addSubview(myLabel)
            
            // Anchor Label so its left aligned but stays in center if text doesn't fill the view
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myLabel.topAnchor.constraint(equalTo: myContentView.topAnchor, constant: 10).isActive = true
            myLabel.bottomAnchor.constraint(equalTo: myContentView.bottomAnchor, constant: -10).isActive = true
            myLabel.centerXAnchor.constraint(equalTo: myContentView.centerXAnchor).isActive = true
            myLabel.widthAnchor.constraint(lessThanOrEqualTo: myContentView.widthAnchor, constant: -20).isActive = true
            
            // Create Clear button to overlay the label
            let myButton = QueryButton()
            myButton.queryText = alt
            myButton.backgroundColor = .clear
            myButton.addTarget(self, action: #selector(alternativesButtonPressed(_:)), for: .touchUpInside)
            myButton.addTarget(self, action: #selector(touchDown1(_:)), for: .touchDown)
            myButton.addTarget(self, action: #selector(cancelEvent1(_:)), for: .touchUpOutside)
            myButton.addTarget(self, action: #selector(cancelEvent1(_:)), for: .touchDragOutside)
            myButton.addTarget(self, action: #selector(touchDown1(_:)), for: .touchDragInside)
            
            // Anchor Button
            myContentView.addSubview(myButton)
            myButton.anchor(top: myContentView.topAnchor,
                            bottom: myContentView.bottomAnchor,
                            leading: myContentView.leadingAnchor,
                            trailing: myContentView.trailingAnchor,
                            height: nil,
                            width: nil)
        }
        
    }
    
    func setupLearnMoreScrollView() {
        
        // Add Header Label and Scroll View to the Main Content View
        mainStackView.addArrangedSubview(learnMoreHeaderLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        mainStackView.addArrangedSubview(learnMoreScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        // Add Stack View to Scroll View
        learnMoreScrollView.addSubview(learnMoreStackView)
        
        learnMoreStackView.anchor(top: learnMoreScrollView.topAnchor,
                                  bottom: learnMoreScrollView.bottomAnchor,
                                  leading: learnMoreScrollView.leadingAnchor,
                                  trailing: learnMoreScrollView.trailingAnchor,
                                  height: nil,
                                  width: nil)
        
        // Prevent Vertical Scrolling
        learnMoreStackView.heightAnchor.constraint(equalTo: learnMoreScrollView.heightAnchor).isActive = true
        
        
        // Populate Alternative Translations Stack View
        populateLearnMoreStackView()
        
    }
    
    func populateLearnMoreStackView() {
        
        if results.count <= 1 && learnMoreArray.count <= 1 {
            
            learnMoreHeaderLabel.superview?.isHidden = true
            learnMoreScrollView.superview?.isHidden = true
            
        }
            
        else if learnMoreArray.count == 0 {
            
            learnMoreHeaderLabel.superview?.isHidden = true
            learnMoreScrollView.superview?.isHidden = true
            
        }
            
        else {
            
            learnMoreHeaderLabel.superview?.isHidden = false
            learnMoreScrollView.superview?.isHidden = false
            
        }
        
        for result in learnMoreArray {
            
            // Create Background Shadow View
            let myView = UIView()
            learnMoreStackView.addArrangedSubview(myView)
            myView.widthAnchor.constraint(equalToConstant: 220).isActive = true
            myView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            // Create Content View
            let myContentView = UIView()
            myContentView.backgroundColor = .white
            myContentView.roundCorners(cornerRadius: 10)
            myView.addSubview(myContentView)
            myContentView.anchor(top: myView.topAnchor,
                                 bottom: myView.bottomAnchor,
                                 leading: myView.leadingAnchor,
                                 trailing: myView.trailingAnchor,
                                 height: nil,
                                 width: nil)
            
            // Formate Atrributed Text
            let attText = NSMutableAttributedString(attributedString: result.text).removeSymbols()
            attText.addAttribute(.font, value: UIFont.systemFont(ofSize: 30), range: NSRange(location: 0, length: attText.length))
            
            // Create Label
            let myLabel = UILabel()
            myLabel.attributedText = attText
            myLabel.numberOfLines = 1
            myLabel.backgroundColor = .white
            myLabel.textAlignment = .left
            myContentView.addSubview(myLabel)
            
            // Anchor Label so its left aligned but stays in center if text doesn't fill the view
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myLabel.topAnchor.constraint(equalTo: myContentView.topAnchor, constant: 10).isActive = true
            myLabel.bottomAnchor.constraint(equalTo: myContentView.bottomAnchor, constant: -10).isActive = true
            myLabel.centerXAnchor.constraint(equalTo: myContentView.centerXAnchor).isActive = true
            myLabel.widthAnchor.constraint(lessThanOrEqualTo: myContentView.widthAnchor, constant: -20).isActive = true
            
            // Create Clear button to overlay the label
            let myButton = QueryButton()
            myButton.queryText = result.text.string.removeSymbols()
            myButton.ipaIndex = result.ipaIndex
            myButton.backgroundColor = .clear
            myButton.addTarget(self, action: #selector(learnMoreButtonPressed(_:)), for: .touchUpInside)
            myButton.addTarget(self, action: #selector(touchDown1(_:)), for: .touchDown)
            myButton.addTarget(self, action: #selector(cancelEvent1(_:)), for: .touchUpOutside)
            myButton.addTarget(self, action: #selector(cancelEvent1(_:)), for: .touchDragOutside)
            myButton.addTarget(self, action: #selector(touchDown1(_:)), for: .touchDragInside)
            
            // Anchor Button
            myContentView.addSubview(myButton)
            myButton.anchor(top: myContentView.topAnchor,
                            bottom: myContentView.bottomAnchor,
                            leading: myContentView.leadingAnchor,
                            trailing: myContentView.trailingAnchor,
                            height: nil,
                            width: nil)
        }
        
    }
    
    func setupGoToFlashcardsButton() {
        
        mainStackView.addArrangedSubview(goToFlashcardBackgroundView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        goToFlashcardBackgroundView.addSubview(goToFlashcardsButton)
        
        goToFlashcardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        goToFlashcardBackgroundView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        goToFlashcardBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        
        goToFlashcardsButton.anchor(top: goToFlashcardBackgroundView.topAnchor,
                                    bottom: goToFlashcardBackgroundView.bottomAnchor,
                                    leading: goToFlashcardBackgroundView.leadingAnchor,
                                    trailing: goToFlashcardBackgroundView.trailingAnchor,
                                    height: nil,
                                    width: nil)
    }
    
    func setupLessonsButton() {
        
        mainStackView.addArrangedSubview(lessonBackgroundView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: -27, right: -20))
        lessonBackgroundView.addSubview(lessonsButton)
        
        lessonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lessonBackgroundView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        lessonBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        
        lessonsButton.anchor(top: lessonBackgroundView.topAnchor,
                             bottom: lessonBackgroundView.bottomAnchor,
                             leading: lessonBackgroundView.leadingAnchor,
                             trailing: lessonBackgroundView.trailingAnchor,
                             height: nil,
                             width: nil)
        
    }
    
    //MARK:- Selector Functions
    
    @objc func profileButtonTapped() {
        
        if Utilities.shared.isUserSignedIn {
            
            Utilities.shared.signUserOut(alertIn: self)
            
        }
            
        else {
            
            goToLogin()
            
        }
        
    }
    
    @objc func alternativesButtonPressed(_ sender: QueryButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.superview?.transform = .identity
            sender.superview?.superview?.layer.shadowOpacity = 0.3
        }
        
        let searchType = (searchInfo.searchType == .englishToNative) ? SearchType.nativeToEnglish : SearchType.englishToNative
        
        let newSearchInfo = SearchInfo(searchType: searchType,
                                       sourceLanguageCode: searchInfo.targetLanguageCode,
                                       sourceLanguageName: searchInfo.targetLanguageName,
                                       targetLanguageCode: searchInfo.sourceLanguageCode,
                                       targetLanguageName: searchInfo.sourceLanguageName)
        
        startSearchSequence(searchText: sender.queryText, newSearchInfo)
        
    }
    
    @objc func learnMoreButtonPressed(_ sender: QueryButton) {
        
        UIView.animate(withDuration: 0.2) {
             sender.superview?.transform = .identity
             sender.superview?.superview?.layer.shadowOpacity = 0.3
         }
        
        let sourceCode = (searchInfo.searchType == .englishToNative) ? searchInfo.sourceLanguageCode : searchInfo.targetLanguageCode
        let sourceName = (searchInfo.searchType == .englishToNative) ? searchInfo.sourceLanguageName : searchInfo.targetLanguageName
        let targetCode = (searchInfo.searchType == .englishToNative) ? searchInfo.targetLanguageCode : searchInfo.sourceLanguageCode
        let targetName = (searchInfo.searchType == .englishToNative) ? searchInfo.targetLanguageName : searchInfo.sourceLanguageName
        
        let newSearchInfo = SearchInfo(searchType: .englishToNative,
                                       sourceLanguageCode: sourceCode,
                                       sourceLanguageName: sourceName,
                                       targetLanguageCode: targetCode,
                                       targetLanguageName: targetName)
        
        startSearchSequence(searchText: sender.queryText, newSearchInfo, ipaIndex: sender.ipaIndex)
        
    }
    
    @objc func goToFlashcardButtonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.7
        }
        
        self.tabBarController?.selectedIndex = 3
    }
    
    @objc func goToLessonButtonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.7
        }
        
        self.tabBarController?.selectedIndex = 4
    }
    
    @objc func touchDown(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.superview?.layer.shadowOpacity = 0.8
        }
    }
    
    @objc func touchDown1(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1) {
            sender.superview?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.superview?.superview?.layer.shadowOpacity = 0.4
        }
    }
    
    @objc func cancelEvent(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.7
        }
        
    }
    
    @objc func cancelEvent1(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            sender.superview?.transform = .identity
            sender.superview?.superview?.layer.shadowOpacity = 0.3
        }
        
    }
}

//MARK: - Result Card Delegate Function

extension LearnMoreController: ResultCardDelegate {
    
    func presentDeckSelectionView() {
        
        let vc = DeckSelectingController()
        vc.bottomLabelText = self.bottomLabelText
        vc.wordArray = self.wordArray
        vc.wordModelArray = self.wordModelArray
        vc.ipaIndex = self.ipaIndex
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func goToLogin() {
        
        let vc = UINavigationController(rootViewController: LoginController())
        let login = vc.viewControllers[0] as! LoginController
        login.isModal = true
        login.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

//MARK: - AddFlashcard Delegate
extension LearnMoreController: AddFlashcardDelegate {
    
    func tapAddFlashcardButton() {
        
        resultCard.addFlashcardButton.sendActions(for: .touchUpInside)
        
    }
    
}

// MARK:- Search Sequence Functions

extension LearnMoreController {
    
    func startSearchSequence(searchText: String,_ searchInfo: SearchInfo, ipaIndex: Int = 0) {
        
        //Update Search Input Variable
        self.searchInput = searchText
        
        //Clear popTip
        resultCard.popTip.hide()
                
        //Set Language Codes
        TranslationManager.shared.sourceLanguageCode = searchInfo.sourceLanguageCode
        TranslationManager.shared.targetLanguageCode = searchInfo.targetLanguageCode
        
        // Clear Results Array
        results = []
        wordArray = []
        bottomLabelText = ""
        wordModelArray = []
        alternateTranslations = []
        soundItOutColors = []
        learnMoreArray = []
        isFullyMatched = true
        
        //Update Query Text
        bottomLabelText = searchText
        
        //Update IpaIndex
        self.ipaIndex = ipaIndex
        
        // Start Loading Screen
        DispatchQueue.main.async {
            self.startLoadingScreen()
        }
        
        // 1. Translate
        // 2. Populate wordModelArray and alternativesArray
        // 3. Color Words
        runSearchsequence(searchText: searchText, searchInfo: searchInfo) { (searchStatus) in
            
            self.searchStatus = searchStatus
            
            switch searchStatus {
                
            case .success,
                 .missingSomeWordModels,
                 .emptyTranslationMissingSomeWordModels,
                 .emptyTranslationWithAllWordModels:
                
                // Populate Results Array
                for (word,wordModel) in zip(self.wordArray, self.wordModelArray) {
                    
                    // If  Word Model Exists, addg colored word and audio to result
                    if let wordModel = wordModel {
                        
                        // Take only the first ipa spelling for now
                        if let ipa = wordModel.ipa[ipaIndex] {
                            
                            // Add Colored Text
                            let audio = (0 < wordModel.audio.count ? wordModel.audio[ipaIndex] : nil)
                            let coloringResult = WordColoringManager.shared.colorWord(word: wordModel.id, ipa: ipa)
                            var text = coloringResult.0
                            text = text.setCapitalLetters(from: word).replaceSpecialCharacters(from: word)
                            self.results.append(ColorResultModel(attributedText: text, audioString: audio, ipa: ipa, isColored: true))
                            
                            // If Text Colored Incorrectly Update isFullyMatched
                            if !coloringResult.1 {
                                self.isFullyMatched = false
                            }
                            
                        }
                                                
                        // Add all ipa spellings for each word to the Learn More Array
                        for i in 0..<wordModel.ipa.count {
                            
                            if let ipa = wordModel.ipa[i] {
                                
                                var text = WordColoringManager.shared.colorWord(word: wordModel.id, ipa: ipa).0
                                text = text.setCapitalLetters(from: word).replaceSpecialCharacters(from: word)
                                self.learnMoreArray.append((text: text, ipaIndex: i))
                            }
                            
                        }
                        
                    }
                        
                    // If Word Model doesn't exist, add plain text to result
                    else {
                        
                        let text = NSMutableAttributedString(string: word)
                        self.results.append(ColorResultModel(attributedText: text, audioString: nil, ipa: "", isColored: false))
                    }
                }
                
                // End Loading Screen
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                    self.pushToLearnMoreController(searchInfo)
                }
                
            case .nilTranslation,
                 .noExistingWordModels,
                 .emptyTranslationNoExistingWordModels:
                
                for word in self.wordArray {
                    
                    self.results.append(ColorResultModel(attributedText: NSMutableAttributedString(string: word),
                                                         audioString: nil, ipa: "", isColored: false))
                    
                }
                
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                    self.pushToLearnMoreController(searchInfo)
                }
            }
        }
    }
    
    func runSearchsequence(searchText: String, searchInfo: SearchInfo, completion: @escaping(_ success: SearchStatus) -> Void) {
        
        switch searchInfo.searchType {
            
        case .nativeToEnglish:
            
            // If source Lang is English, retrieve word models from database
            if TranslationManager.shared.sourceLanguageCode == "en" {
                
                self.searchOutput = searchText
                
                self.wordArray = searchText.replacingOccurrences(of: "’", with: "'").split(separator: " ").map {String($0)}
                
                FirebaseManager.shared.readEnglishDocumentByWord(words: wordArray) { (wordModelArray) in
                    
                    self.wordModelArray = wordModelArray
                    
                    let filteredArray = wordModelArray.filter { $0 != nil }
                    
                    // All Word Models Found
                    if wordModelArray.count > 0 && wordModelArray.count == filteredArray.count { completion(.success) }
                        
                    // Some Word Models Found
                    else if wordModelArray.count > 0 && filteredArray.count > 0 { completion(.missingSomeWordModels) }
                        
                    // No Word Models Found
                    else { completion(.noExistingWordModels) }
                }
            }
                
            // Otherwise get translations and then retrieve word models from database
            else {
                
                var isEmptyTranslation = true
                
                TranslationManager.shared.textToTranslate = searchText
                TranslationManager.shared.translate { (translation) in
                    
                    guard var translation = translation else {
                        print("Translation is nil")
                        self.searchOutput = searchText
                        self.wordArray = searchText.split(separator: " ").map { String($0) }
                        completion(.nilTranslation)
                        return
                    }
                    
                    // Populate Alternate Translations
                    if translation.count > 1 {
                        self.alternateTranslations = translation[1..<translation.count].map { String($0) }
                    }
                    
                    // If the Translation Returns an empty string we want the result to be the original searched Text
                    if translation[0] == "" {
                        
                        translation[0] = searchText
                        
                    } else { isEmptyTranslation = false }
                    
                    self.searchOutput = translation[0]
                    
                    self.wordArray = translation[0].split(separator: " ").map { String($0) }
                    
                    // Retrieve word models from database
                    FirebaseManager.shared.readEnglishDocumentByWord(words: self.wordArray) { (wordModelArray) in
                        
                        self.wordModelArray = wordModelArray
                        
                        let filteredArray = wordModelArray.filter { $0 != nil }
                        
                        // All  Word Models Found
                        if wordModelArray.count > 0 && wordModelArray.count == filteredArray.count {
                            
                            if isEmptyTranslation { completion(.emptyTranslationWithAllWordModels) }
                                
                            else { completion(.success); self.linkNativeToEnglish(self.wordModelArray) }
                            
                        }
                        
                        // Some Word Models Found
                        else if wordModelArray.count > 0 && filteredArray.count > 0 {
                            
                            if isEmptyTranslation { completion(.emptyTranslationMissingSomeWordModels) }
                            
                            else { completion(.missingSomeWordModels); self.linkNativeToEnglish(self.wordModelArray) }
                            
                        }
                        
                        // No Word Models Found
                        else {
                            
                            if isEmptyTranslation { completion(.emptyTranslationNoExistingWordModels) }
                            
                            else { completion(.noExistingWordModels) }
                            
                        }
                    }
                }
            }
            
        case .englishToNative:
            
            // If Target Lang is English, retrieve word models from database
            if TranslationManager.shared.targetLanguageCode == "en" {
                
                self.searchOutput = searchText
                
                self.wordArray = searchText.replacingOccurrences(of: "’", with: "'").split(separator: " ").map {String($0)}
                
                FirebaseManager.shared.readEnglishDocumentByWord(words: wordArray) { (wordModelArray) in
                    
                    self.wordModelArray = wordModelArray
                    
                    let filteredArray = wordModelArray.filter { $0 != nil }
                    
                    // All Word Models Found
                    if wordModelArray.count > 0 && wordModelArray.count == filteredArray.count { completion(.success) }
                    
                    // Some Word Models Found
                    else if wordModelArray.count > 0 && filteredArray.count > 0 { completion(.missingSomeWordModels) }
                    
                    // No Word Models Found
                    else { completion(.noExistingWordModels) }
                }
            }
                
            // Otherwise get translations and then retrieve word models from database
            else {
                
                var isEmptyTranslation = true
                
                TranslationManager.shared.textToTranslate = searchText
                TranslationManager.shared.translate { (translation) in
                    
                    guard var translation = translation else {
                        print("Translation is nil")
                        self.searchOutput = searchText
                        self.wordArray = searchText.split(separator: " ").map { String($0) }
                        completion(.nilTranslation)
                        return
                    }
                    
                    // Populate Alternate Translations
                    if translation.count > 1 {
                        self.alternateTranslations = translation[1..<translation.count].map { String($0) }
                    }
                    
                    // If the Translation Returns an empty string we want the result to be the original searched Text
                    if translation[0] == "" {
                        
                        translation[0] = searchText
                        
                    } else { isEmptyTranslation = false }
                    
                    self.searchOutput = translation[0]
                    
                    self.bottomLabelText = translation[0]
                    
                    self.wordArray = searchText.split(separator: " ").map { String($0) }
                    
                    // Retrieve word models from database
                    FirebaseManager.shared.readEnglishDocumentByWord(words: self.wordArray) { (wordModelArray) in
                        
                        self.wordModelArray = wordModelArray
                        
                        let filteredArray = wordModelArray.filter { $0 != nil }
                        
                        // All  Word Models Found
                        if wordModelArray.count > 0 && wordModelArray.count == filteredArray.count {
                            
                            if isEmptyTranslation { completion(.emptyTranslationWithAllWordModels) }
                                
                            else { completion(.success); self.linkNativeToEnglish(self.wordModelArray) }
                            
                        }
                        
                        // Some Word Models Found
                        else if wordModelArray.count > 0 && filteredArray.count > 0 {
                            
                            if isEmptyTranslation { completion(.emptyTranslationMissingSomeWordModels) }
                            
                            else { completion(.missingSomeWordModels); self.linkNativeToEnglish(self.wordModelArray) }
                            
                        }
                        
                        // No Word Models Found
                        else {
                            
                            if isEmptyTranslation { completion(.emptyTranslationNoExistingWordModels) }
                            
                            else { completion(.noExistingWordModels) }
                            
                        }
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
    
    func pushToLearnMoreController(_ searchInfo: SearchInfo) {
        
        // Initialize result controller
        let vc = LearnMoreController()
        
        // Populate LearnMore Controller Data
        vc.searchInfo = searchInfo
        vc.bottomLabelText = self.bottomLabelText
        vc.ipaIndex = 0
        vc.wordArray = self.wordArray
        vc.wordModelArray = self.wordModelArray
        vc.results = self.results
        vc.alternateTranslations = self.alternateTranslations
        vc.learnMoreArray = self.learnMoreArray
        vc.searchStatus = self.searchStatus
        vc.isFullyMatched = self.isFullyMatched
        
        // Update Search History
        if Utilities.shared.isUserSignedIn {
            
            if var user = Utilities.shared.user {
                
                let searchType = searchInfo.searchType == .nativeToEnglish ? 0 : 1
                let fbSearchinfo = FBSearchInfo(searchType: searchType,
                                                sourceLanguageCode: searchInfo.sourceLanguageCode,
                                                sourceLanguageName: searchInfo.sourceLanguageName,
                                                targetLanguageCode: searchInfo.targetLanguageCode,
                                                targetLanguageName: searchInfo.targetLanguageName)
                
                let info = SearchAndResult(searchText: self.searchInput, resultText: self.searchOutput, searchInfo: fbSearchinfo)
                
                user.prevSearches.insert(info, at: 0)
                
                if user.prevSearches.count > 50 { _ =  user.prevSearches.popLast() }
                
                Utilities.shared.user = user
                FirebaseManager.shared.updateUser(user: user)
            }
            
        }
        
        // Create sound it out buttons for result controller
        if results.count == 1 {
            
            vc.soundItOutColors = self.createButtons(results[0].attributedText)
            
        } else { vc.soundItOutColors = [] }
        
        // Push Result Controller
        navigationController?.pushViewController(vc, animated: true)
    }
}


