//
//  ResultsController.swift
//  Aura
//
//  Created by Max Dolensky on 7/9/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import AVFoundation
import AMPopTip
import Speech

protocol ResultsControllerDelegate {
    
    func updateLanguageStackView(searchInfo: SearchInfo)
    
}

class ResultsController: UIViewController {
    
//MARK: - Data
    
    var bottomLabelText = ""
    var searchInput = ""
    var searchOutput = ""
    var ipaIndex = 0
    var wordArray = [String]()
    var wordModelArray = [WordModel?]()
    var results = [ColorResultModel]()
    var dictionaryResult = [String : [DictionaryResult]]()
    var soundItOutColors = [(color: UIColor, ID: String, range: NSRange)]()
    var learnMoreArray = [(text: NSMutableAttributedString, ipaIndex: Int)]()
    var isFullyMatched = true
    var learnMoreIsFullyMatched = true
    var searchStatus: SearchStatus!
    var learnMoreSearchStatus: SearchStatus!
    
    var textViewHeight: NSLayoutConstraint!
    

    // Search Information
    var searchInfo = SearchInfo(sourceLanguageCode: "en", sourceLanguageName: "English") {
        
        didSet {
            
            updateMicButtonVisibility()
            
        }
        
    }
    
//MARK: - Utilities
    
    let cellID = "SoundItOutCell"
    var delegate: ResultsControllerDelegate?
        
//MARK: - Views
    
    var centerTitle: UILabel = {
       
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        label.backgroundColor = .clear
        label.font = UIFont(name: K.Fonts.avenirBlack, size: 17)
        label.text = "Results"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var languageBarView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.setUnderlineStyle(color: K.Colors.lightGrey)
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
        button.titleLabel!.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(K.DesignColors.primary, for: .normal)
        return button
        
    }()
    
    var swapButton: UIButton = {
        
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "arrow.right.arrow.left.circle"), for: .normal)
        } else {
            button.setImage(#imageLiteral(resourceName: "arrow.right.arrow.left").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        button.addTarget(self, action: #selector(swapButtonPressed), for: .touchUpInside)
        button.tintColor = K.DesignColors.primary
        button.backgroundColor = .white
        return button
        
    }()
    
    var englishLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Am. English HD"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    var textViewBackgroundView = UIView()
    
    var textView: UITextView = {
        
        let textView = UITextView()
        textView.returnKeyType = .search
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 50)
        textView.backgroundColor = .white
        return textView
    
    }()
    
    var micButton: UIButton = {
        
        let button = UIButton()
        
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        } else {
            button.setImage(#imageLiteral(resourceName: "mic.fill").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        button.backgroundColor = K.DesignColors.primary
        button.tintColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.roundCorners(cornerRadius: 20)
        
        button.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        
        return button
        
    }()
    
    var searchButton: UIButton = {
        
        let button = UIButton()
        
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        } else {
            button.setImage(#imageLiteral(resourceName: "arrow.forward").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.backgroundColor = K.DesignColors.primary
        button.tintColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.roundCorners(cornerRadius: 20)
        
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        
        return button
        
    }()
    
    var cancelButton: UIButton = {
        
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "multiply"), for: .normal)
        } else {
            button.setImage(#imageLiteral(resourceName: "multiply").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.isHidden = true
        return button
        
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
        
    var alternativeCard = AltTranslationsView()
    
    var learnMoreScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.masksToBounds = false
        return scrollView
        
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
        label.text = "Related Searches"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        return label
        
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
        
    var lessonsButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Lessons", for: .normal)
        if UIScreen.main.bounds.width > 320 {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        }
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
        
    let lessonBackgroundView = UIView()

//MARK: - Class Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.DesignColors.background
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultCard.topLabel.adjustsMultiLineFontToFitWidth()
        resultCard.bottomLabel.adjustsMultiLineFontToFitWidth()
        setupShadows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        resultCard.updateLoopColor()
        
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
        
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateLanguageStackView(searchInfo: self.searchInfo)
    }
}

extension ResultsController {
    
//MARK:- View Setup Functions
    
    func setupView() {
        self.setupToHideKeyboardOnTapOnView()
        setupNavBar()
        setupLanguageSelectionView()
        setupTextView()
        setupScrollView()
    }
    
    func setupShadows() {
        
        textViewBackgroundView.setShadowWithBZPath(color: UIColor.black, opacity: 0.3, offset: .init(width: 0, height: 3), radius: 2)
        
        searchStatusView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
        resultBackgroundView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
        resultCard.addFlashcardBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 30)
        
        resultCard.loopBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 21)
        
        resultCard.playBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 21)
        
        resultCard.reportErrorBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 21)
              
        alternativeCard.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 3, cornerRadius: 21)
        
        for view in learnMoreStackView.arrangedSubviews {
            view.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
                
        lessonBackgroundView.setShadow(color: .black, opacity: 0.7, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        
        for v in myDecksScrollView.stackView.subviews {
            v.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
    }
    
    func setupNavBar() {
        
        // Add Center Title
        self.navigationItem.titleView = centerTitle
        self.navigationController?.navigationBar.topItem?.title = " "
                
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.DesignColors.primary

    }
    
    func setupLanguageSelectionView() {
        
        // Add Language Bar View
        view.addSubview(languageBarView)
        
        languageBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                               bottom: nil,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               height: 60,
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
        
        // Add Subviews To StackView
        switch searchInfo.searchType {
        
        case.englishToNative:
            languageButton.setTitle(searchInfo.targetLanguageName, for: .normal)
            langStackView.addArrangedSubview(englishLabel)
            langStackView.addArrangedSubview(swapButton)
            langStackView.addArrangedSubview(languageButton)
            
        case.nativeToEnglish:
            languageButton.setTitle(searchInfo.sourceLanguageName, for: .normal)
            langStackView.addArrangedSubview(languageButton)
            langStackView.addArrangedSubview(swapButton)
            langStackView.addArrangedSubview(englishLabel)
        }
    }
    
    func updateLanguageStackView() {
        
        for view in langStackView.arrangedSubviews {
            langStackView.removeArrangedSubview(view)
        }
        
        // Add Subviews To StackView
        switch searchInfo.searchType {
        
        case.englishToNative:
            languageButton.setTitle(searchInfo.targetLanguageName, for: .normal)
            langStackView.addArrangedSubview(englishLabel)
            langStackView.addArrangedSubview(swapButton)
            langStackView.addArrangedSubview(languageButton)
            
        case.nativeToEnglish:
            languageButton.setTitle(searchInfo.sourceLanguageName, for: .normal)
            langStackView.addArrangedSubview(languageButton)
            langStackView.addArrangedSubview(swapButton)
            langStackView.addArrangedSubview(englishLabel)
        }
        
    }
    
    func fetchLocale() -> String {
        
        let currentLangCode = String(searchInfo.sourceLanguageCode[0...1])
        let phoneLanguageCode = String(Locale.preferredLanguages[0][0...1])
        
        let finalLangCode = currentLangCode == phoneLanguageCode ? Locale.preferredLanguages[0] : searchInfo.sourceLanguageCode
        
        return finalLangCode
    }
    
    func updateMicButtonVisibility() {
        
        let localeString = fetchLocale()
        
        if let isAvailable = SFSpeechRecognizer(locale: Locale(identifier: localeString))?.isAvailable {
            
            if isAvailable {
                micButton.isHidden = false
            }
            else {
                micButton.isHidden = true
            }
            return
        }
        else {
            micButton.isHidden = true
        }
    }
    
    func setupTextView() {
        
        // Add View
        view.addSubview(textViewBackgroundView)
        
        textViewBackgroundView.anchor(top: langStackView.bottomAnchor,
                                      bottom: nil,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor,
                                      height: nil,
                                      width: nil,
                                      padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
        
        textViewHeight = textViewBackgroundView.heightAnchor.constraint(equalToConstant: 140)
        textViewHeight.isActive = true
        
        // Add TextView
        textView.delegate = self
        
        textViewBackgroundView.addSubview(textView)
        
        textView.anchor(top: textViewBackgroundView.topAnchor,
                        bottom: textViewBackgroundView.bottomAnchor,
                        leading: textViewBackgroundView.leadingAnchor,
                        trailing: textViewBackgroundView.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        
        // Add X Button
        textViewBackgroundView.addSubview(cancelButton)
        cancelButton.anchor(top: textView.topAnchor,
                            bottom: nil,
                            leading: nil,
                            trailing: textView.trailingAnchor,
                            height: 40,
                            width: 40,
                            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        // Add Search Button
        textViewBackgroundView.addSubview(searchButton)
        searchButton.anchor(top: nil,
                        bottom: textView.bottomAnchor,
                        leading: nil,
                        trailing: textView.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 0, left: 0, bottom: -10, right: -10))
                
        // Add Mic Button
        textViewBackgroundView.addSubview(micButton)
        micButton.anchor(top: nil,
                        bottom: textView.bottomAnchor,
                        leading: nil,
                        trailing: searchButton.leadingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 0, left: 0, bottom: -10, right: -10))
        
        updateMicButtonVisibility()
        view.bringSubviewToFront(languageBarView)
        
    }
    
    func setupScrollView() {
        
        mainScrollView.delegate = self
        
        // Add scroll view and content view
        view.addSubview(mainScrollView)
        view.sendSubviewToBack(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        
        // Anchor Scroll View
        mainScrollView.anchor(top: langStackView.bottomAnchor,
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
                           width: nil,
                           padding: UIEdgeInsets(top: 140 + 30, left: 0, bottom: 0, right: 0))
        
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
        mainStackView.addArrangedSubview(searchStatusView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        searchStatusView.superview?.isHidden = true
        
        // Add Results Card to Stack View
        mainStackView.addArrangedSubview(resultBackgroundView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        
        // Add Alternatives Card
        setupAlternativesView()
        
        // Setup Learn More Scroll View
        setupLearnMoreScrollView()
        
        // Setup FlashCard UpSaleButton
        setupMyFlashcards()
        
        // Setup Lessons UpSaleButton
        setupLessonsButton()
    
    }
    
    func setupAlternativesView() {
        
        self.alternativeCard = AltTranslationsView(frame: .zero, searchedText: self.searchInput, dictionaryResult: self.dictionaryResult, searchInfo: self.searchInfo)
        self.alternativeCard.delegate = self
        mainStackView.addArrangedSubview(alternativeCard, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        
        if self.dictionaryResult.count == 0 {
            self.alternativeCard.superview?.isHidden = true
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
    
    func setupMyFlashcards() {
        
        // Initialize My Decks Scroll View
        if let decks = Utilities.shared.user?.decks {
            myDecksScrollView = MyDecksScrollView(frame: .zero, decks: decks)
            myDecksScrollView.myDeckDelegate = self
        } else {
            myDecksScrollView = MyDecksScrollView(frame: .zero)
            myDecksScrollView.myDeckDelegate = self
        }
        
        mainStackView.addArrangedSubview(myDecksLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        
        mainStackView.addArrangedSubview(myDecksScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        
        myDecksScrollView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Update My Decks Visibility
        myDecksScrollView.updateVisibility()
        if myDecksScrollView.decks.count == 0 {
            myDecksLabel.superview?.isHidden = true
        }
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
        
    @objc func languageButtonPressed() {
                
        let supportedLanguagesVC = SupportedLanguagesVC()
        supportedLanguagesVC.delegate = self
        
        if AzureTranslationManager.shared.supportedLanguages.count == 0 {
            
            DispatchQueue.main.async {
                self.startLoadingScreen()
            }
            
            AzureTranslationManager.shared.fetchSupportedLanguages {
                
                supportedLanguagesVC.supportedLanguages = AzureTranslationManager.shared.supportedLanguages
                
                DispatchQueue.main.async {
                    self.endLoadingScreen()
                    self.present(supportedLanguagesVC, animated: true, completion: nil)
                }
            }
        }
            
        else {
            
            supportedLanguagesVC.supportedLanguages = AzureTranslationManager.shared.supportedLanguages
                        
            self.present(supportedLanguagesVC, animated: true, completion: nil)
            
        }
    }
    
    @objc func swapButtonPressed() {
        
        // Change Search Type and If Necessary, Change English HD to English
        switch self.searchInfo.searchType {
            
        case .englishToNative:
            self.searchInfo.searchType = .nativeToEnglish
            
        case .nativeToEnglish:
            self.searchInfo.searchType = .englishToNative
            
        }
        
        // Swap Source And Target Language Codes and Names
        let tempSourceCode = searchInfo.sourceLanguageCode
        searchInfo.sourceLanguageCode = searchInfo.targetLanguageCode
        searchInfo.targetLanguageCode = tempSourceCode
        
        let tempSourceName = searchInfo.sourceLanguageName
        searchInfo.sourceLanguageName = searchInfo.targetLanguageName
        searchInfo.targetLanguageName = tempSourceName
        
        DispatchQueue.main.async {
            
            // Retrieve Subviews
            let subviews = self.langStackView.arrangedSubviews
            
            let sub0 = subviews[0]
            let sub1 = subviews[1]
            let sub2 = subviews[2]
                        
            // Clear Subviews
            for subview in self.langStackView.arrangedSubviews {
                self.langStackView.removeArrangedSubview(subview)
            }
            
            // Add Subviews Flipped
            UIView.animate(withDuration: 0.3) {
                self.langStackView.addArrangedSubview(sub2)
                self.langStackView.addArrangedSubview(sub1)
                self.langStackView.addArrangedSubview(sub0)
            }
        }
    }
    
    @objc func cancelButtonPressed() {
        textView.text = ""
        textView.textColor = .lightGray
        textView.text = "Enter text"
        cancelButton.isHidden = true
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
        
        startSearchSequence(searchText: sender.queryText, newSearchInfo, isLearnMore: true)
        
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
        
        startSearchSequence(searchText: sender.queryText, newSearchInfo, ipaIndex: sender.ipaIndex, isLearnMore: true)
        
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
    
    @objc func recordPressed() {
        
        let vc = SpeechToTextController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: self.fetchLocale()))!
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func searchPressed() {
        if textView.text != nil && textView.text.count > 0 {
            textView.resignFirstResponder()
            startSearchSequence(searchText: textView.text!, searchInfo)
        }
    }
    
}

//MARK:- UITextView Delegate Methods

extension ResultsController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        DispatchQueue.main.async {
            
            if textView.textColor == .lightGray {
                textView.text = ""
                textView.textColor = .black
                self.cancelButton.isHidden = false
            }
            
            else if textView.textColor == .black && textView.text.count >= 0 {
                self.cancelButton.isHidden = false
            }
            
        }
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        DispatchQueue.main.async {
            
            if textView.text.isEmpty || textView.text == "" {
                textView.textColor = .lightGray
                textView.text = "Enter text"
                self.cancelButton.isHidden = true
            }
            
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

//MARK: - Result Card Delegate Function

extension ResultsController: ResultCardDelegate {
    
    func presentReportErrorAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
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
extension ResultsController: AddFlashcardDelegate {
    
    func tapAddFlashcardButton() {
        
        resultCard.addFlashcardButton.sendActions(for: .touchUpInside)
        
    }
    
}


//MARK: - Language Selection Functions

extension ResultsController: SupportedLanguagesDelegate  {
    
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
}

// MARK:- Search Sequence Functions

extension ResultsController {
    
    func startSearchSequence(searchText: String,_ searchInfo: SearchInfo, ipaIndex: Int = 0, isLearnMore: Bool = false) {
        
        //Update Search Input Variable
        self.searchInput = searchText
        
        //Clear popTip
        resultCard.popTip.hide()
        
        //Update global SearchInfo
        if !isLearnMore {
            self.searchInfo = searchInfo
        }
        
        //Set Language Codes
        AzureTranslationManager.shared.sourceLanguageCode = searchInfo.sourceLanguageCode
        AzureTranslationManager.shared.targetLanguageCode = searchInfo.targetLanguageCode
        
        // Clear Results Array
        results = []
        wordArray = []
        bottomLabelText = ""
        wordModelArray = []
        soundItOutColors = []
        learnMoreArray = []
        dictionaryResult = [:]
        
        if isLearnMore {
            learnMoreIsFullyMatched = true
        } else { isFullyMatched = true }
        
        
        //Update Query Text
        bottomLabelText = searchText
        
        //Update IpaIndex
        self.ipaIndex = ipaIndex
        
        // Start Loading Screen
        DispatchQueue.main.async {
            self.startLoadingScreen()
        }
        
        // Create And Enter Dispatch Group For Tranlsation Request
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        // 1. Translate
        // 2. Color Words
        runSearchsequence(searchText: searchText, searchInfo: searchInfo) { (searchStatus) in
            
            if isLearnMore {
                self.learnMoreSearchStatus = searchStatus
            }
            
            else {
                self.searchStatus = searchStatus
            }
            
            
            switch searchStatus {
                
            case .success,
                 .missingSomeWordModels,
                 .emptyTranslationMissingSomeWordModels,
                 .emptyTranslationWithAllWordModels:
            
                // Populate Results Array with ColorResultModel
                for (word,wordModel) in zip(self.wordArray, self.wordModelArray) {
                    
                    // If  Word Model Exists, add colored word and audio to result
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
                                
                                if isLearnMore {
                                    self.learnMoreIsFullyMatched = false
                                } else { self.isFullyMatched = false }
                                
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
                
                dispatchGroup.leave()
                
            case .nilTranslation,
                 .noExistingWordModels,
                 .emptyTranslationNoExistingWordModels:
                
                for word in self.wordArray {
                    
                    self.results.append(ColorResultModel(attributedText: NSMutableAttributedString(string: word),
                                                         audioString: nil, ipa: "", isColored: false))
                    
                }
                
                self.isFullyMatched = false
                
                dispatchGroup.leave()
            }
        }
        
        if !(AzureTranslationManager.shared.sourceLanguageCode == "en" && AzureTranslationManager.shared.targetLanguageCode == "en") {
            
            dispatchGroup.enter()
            AzureTranslationManager.shared.fetchDictionaryTranslations { (dictionaryResult) in
                
                self.dictionaryResult = dictionaryResult
                dispatchGroup.leave()
                
            }
            
        }
        
        dispatchGroup.notify(queue: .main) {
            
            DispatchQueue.main.async {
                
                self.endLoadingScreen()
                
                if !isLearnMore { self.updateResultsVC() }
                    
                else { self.pushToLearnMoreController(searchInfo) }
                
                print(self.dictionaryResult)
            }
        }
    }
    
    func runSearchsequence(searchText: String, searchInfo: SearchInfo, completion: @escaping(_ success: SearchStatus) -> Void) {
        
        switch searchInfo.searchType {
            
        case .nativeToEnglish:
            
            // If source Lang is English, retrieve word models from database
            if AzureTranslationManager.shared.sourceLanguageCode == "en" {
                
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
                
                AzureTranslationManager.shared.textToTranslate = searchText
                AzureTranslationManager.shared.fetchTranslation { (translation) in
                    
                    guard var translation = translation else {
                        print("Translation is nil")
                        self.searchOutput = searchText
                        self.wordArray = searchText.split(separator: " ").map { String($0) }
                        completion(.nilTranslation)
                        return
                    }
                
                    // If the Translation Returns an empty string we want the result to be the original searched Text
                    if translation == "" {
                        
                        translation = searchText
                        
                    } else { isEmptyTranslation = false }
                    
                    self.searchOutput = translation
                    
                    self.wordArray = translation.split(separator: " ").map { String($0) }
                    
                    // Retrieve word models from database
                    FirebaseManager.shared.readEnglishDocumentByWord(words: self.wordArray) { (wordModelArray) in
                        
                        self.wordModelArray = wordModelArray
                        
                        let filteredArray = wordModelArray.filter { $0 != nil }
                        
                        // All  Word Models Found
                        if wordModelArray.count > 0 && wordModelArray.count == filteredArray.count {
                            
                            if isEmptyTranslation { completion(.emptyTranslationWithAllWordModels) }
                                
                            else { completion(.success) }
                            
                        }
                        
                        // Some Word Models Found
                        else if wordModelArray.count > 0 && filteredArray.count > 0 {
                            
                            if isEmptyTranslation { completion(.emptyTranslationMissingSomeWordModels) }
                            
                            else { completion(.missingSomeWordModels) }
                            
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
            if AzureTranslationManager.shared.targetLanguageCode == "en" {
                
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
                
                AzureTranslationManager.shared.textToTranslate = searchText
                AzureTranslationManager.shared.fetchTranslation { (translation) in
                    
                    guard var translation = translation else {
                        print("Translation is nil")
                        self.searchOutput = searchText
                        self.wordArray = searchText.split(separator: " ").map { String($0) }
                        completion(.nilTranslation)
                        return
                    }
                    
                    // If the Translation Returns an empty string we want the result to be the original searched Text
                    if translation == "" {
                        
                        translation = searchText
                        
                    } else { isEmptyTranslation = false }
                    
                    self.searchOutput = translation
                    
                    self.bottomLabelText = translation
                    
                    self.wordArray = searchText.split(separator: " ").map { String($0) }
                    
                    // Retrieve word models from database
                    FirebaseManager.shared.readEnglishDocumentByWord(words: self.wordArray) { (wordModelArray) in
                        
                        self.wordModelArray = wordModelArray
                        
                        let filteredArray = wordModelArray.filter { $0 != nil }
                        
                        // All  Word Models Found
                        if wordModelArray.count > 0 && wordModelArray.count == filteredArray.count {
                            
                            if isEmptyTranslation { completion(.emptyTranslationWithAllWordModels) }
                                
                            else { completion(.success) }
                            
                        }
                        
                        // Some Word Models Found
                        else if wordModelArray.count > 0 && filteredArray.count > 0 {
                            
                            if isEmptyTranslation { completion(.emptyTranslationMissingSomeWordModels) }
                            
                            else { completion(.missingSomeWordModels) }
                            
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
        
    func updateResultsVC() {
        
        // Update search history
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
        
        checkForColorError()
        
        // Update Views in Results VC
        DispatchQueue.main.async {
            
            // Update Languages Stack View
            self.updateLanguageStackView()
            
            // Update Result Card
            self.resultCard.results = self.results
            self.resultCard.bottomLabelText = self.bottomLabelText
            self.resultCard.updateResultSubviewVisibilities()
            
            // Configure Top Label Text
            let topAttributedText = NSMutableAttributedString()
            
            for i in 0..<self.results.count {
                
                topAttributedText.append(self.results[i].attributedText)
                
                if i != self.results.count - 1 {
                    topAttributedText.append(NSAttributedString(string: " "))
                }
            }
            
            self.resultCard.topLabel.attributedText = topAttributedText
            self.resultCard.topLabel.configureBasedOnInput()
            
            // Configure Bottom Label Text
            self.resultCard.bottomLabel.attributedText = NSAttributedString(string: self.bottomLabelText)
            self.resultCard.bottomLabel.configureBottomLabel()
            
            // Update Collection View
            self.soundItOutColors = createButtons(self.results[0].attributedText)
            self.resultCard.soundItOutColors = self.soundItOutColors
            self.resultCard.soundItOutCollectionView.reloadData()
             
            // Update Alternatives View
            if self.dictionaryResult.count != 0 {
                
                self.alternativeCard.update(searchedText: self.searchInput, dictionaryResult: self.dictionaryResult)
                self.alternativeCard.superview?.isHidden = false
                self.alternativeCard.searchInfo = self.searchInfo
                
            } else { self.alternativeCard.superview?.isHidden = true }
            
            // Clear then re-populate Learn More Stack View
            for view in self.learnMoreStackView.arrangedSubviews {
                view.removeFromSuperview()
            }
            
            self.populateLearnMoreStackView()
            self.setupShadows()
            
            self.mainScrollView.setContentOffset(.zero, animated: true)
            
            if self.searchStatus != .success {
                
                self.searchStatusView.setLabelText(status: self.searchStatus)
                self.searchStatusView.superview?.isHidden = false
                
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
            
            else { self.searchStatusView.superview?.isHidden = true }
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
        vc.dictionaryResult = self.dictionaryResult
        vc.learnMoreArray = self.learnMoreArray
        vc.searchStatus = self.learnMoreSearchStatus
        vc.isFullyMatched = self.learnMoreIsFullyMatched
        vc.searchInput = self.searchInput
        vc.searchOutput = self.searchOutput
        vc.checkForColorError()
        
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
            
            vc.soundItOutColors = createButtons(results[0].attributedText)
            
        } else { vc.soundItOutColors = [] }
        
        // Push Result Controller
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - AltTranslation Delegate Methods
extension ResultsController: AltTranslationDelegate {
    
    func searchBackTranslation(backTranslation: String, searchInfo: SearchInfo) {
        
        startSearchSequence(searchText: backTranslation, searchInfo, isLearnMore: true)
        self.textView.text = backTranslation
    }

}

// MARK: - Scroll View Delegate Methods
extension ResultsController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        textView.resignFirstResponder()
        
        if !searchStatusView.superview!.isHidden {
            
            DispatchQueue.main.async {
                
                self.searchStatusView.superview?.isHidden = true
                
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        let offset = scrollView.contentOffset.y
        var difference = (0 - offset)
        if difference > 0 {
            difference = 0
        }
        
        DispatchQueue.main.async {
           
            self.textViewBackgroundView.transform = CGAffineTransform(translationX: 0, y: difference * 1.4)

        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            
            let offset = scrollView.contentOffset.y
            
            DispatchQueue.main.async {
                if offset <= 50 {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                } else if offset <= 140 {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
                }
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        DispatchQueue.main.async {
            if offset <= 50 {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else if offset <= 140 {
                scrollView.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
            }
        }
    }
}

// MARK: - Utilities
extension ResultsController {
    
    func checkForColorError() {
        
        if !self.isFullyMatched {
            
            var text = ""
            
            if self.searchInfo.searchType == .englishToNative {
                text = self.searchInput
            }
            
            else {
                text = self.searchOutput
            }
            
            FirebaseManager.shared.writeColorError(text: text)
            
        }
        
    }
}

extension ResultsController: SpeechToTextDelegate {
    
    func updateText(with transcription: String, shouldPerformSearch: Bool) {
        
        textView.textColor = .black
        textView.text = transcription
        cancelButton.isHidden = false
        
        if shouldPerformSearch {
            startSearchSequence(searchText: transcription, searchInfo)
           
        }
    }
    
}

extension ResultsController: DeckUpdater {
    
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
}

extension ResultsController: MyDeckDelegate {
    
    func goToDeck(deckIndex: Int) {
        
        if let controllers = tabBarController?.viewControllers {
            if let navVC = controllers[3] as? UINavigationController {
                navVC.popToRootViewController(animated: false)
                if let rootVC = navVC.viewControllers[0] as? FlashCardController {
                    rootVC.goToDeck(deckIndex: deckIndex)
                    self.tabBarController?.selectedIndex = 3
                }
                
            }
        }
        
    }
    
}
