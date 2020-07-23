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

protocol ResultsControllerDelegate {
    
    func updateLanguageStackView(searchType: SearchType)
    
}

class ResultsController: UIViewController {
    
//MARK: - Data
    
    var searchType = SearchType.nativeToEnglish
    var bottomLabelText = ""
    var wordArray = [String]()
    var wordModelArray = [WordModel?]()
    var results = [ColorResultModel]()
    var soundItOutColors = [(color: UIColor, ID: String, range: NSRange)]()
    var alternateTranslations = [String]()
    
//MARK: - Utilities
    
    let cellID = "SoundItOutCell"
    var delegate: ResultsControllerDelegate?
    var player : AVPlayer?
    var soundItOutPlayer: AVAudioPlayer?
    
    let popTip: PopTip =  {
        
        let popTip = PopTip()
        popTip.shouldDismissOnTap = true
        popTip.bubbleColor = .white
        popTip.borderColor = .black
        popTip.borderWidth = 1.0
        return popTip
        
    }()
    
    var prevRange: NSRange?
        
//MARK: - Views
    
    var centerTitle: UILabel = {
       
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
    
    var textViewBackgroundView = UIView()
    
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
    
    var mainScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = K.Colors.lightGrey
        return scrollView
        
    }()
    
    var mainContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = K.Colors.lightGrey
        return view
        
    }()
    
    var resultCardView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners(cornerRadius: 10)
        return view
        
    }()
    
    var topLabel: UILabel = {
        
        let label = UILabel()
        label.clipsToBounds = false
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byWordWrapping
        label.baselineAdjustment = .none
        return label
        
    }()
    
    var bottomLabel = UILabel()
    
    var soundButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.3.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(soundButtonPressed(_:)), for: .touchUpInside)
        return button
        
    }()
    
    var loopButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.3.trianglepath"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(loopButtonPressed(_:)), for: .touchUpInside)
        return button
        
    }()
    
    var lineDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = K.Colors.purple
        return view
    }()
    
    var addFlashcardButton: UIButton = {
       
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = K.Colors.purple
        button.tintColor = .white
        button.roundCorners(cornerRadius: 15)
        button.addTarget(self, action: #selector(addFlashcardButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    var soundItOutCollectionView: UICollectionView = {
       
        let cv = DynamicCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        return cv
        
    }()
    
    var alternativesScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = K.Colors.lightGrey
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.masksToBounds = false
        return scrollView
        
    }()
    
    var alternativesContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = K.Colors.lightGrey
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
        label.backgroundColor = K.Colors.lightGrey
        label.text = "Alternative Translations"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        return label
        
    }()
    
    var learnMoreScrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = K.Colors.lightGrey
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.masksToBounds = false
        return scrollView
        
    }()
    
    var learnMoreContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = K.Colors.lightGrey
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
        label.backgroundColor = K.Colors.lightGrey
        label.text = "Learn More"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        return label
        
    }()
    
    var goToFlashcardsButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Add Flashcard", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        button.tintColor = .white
        button.setBackgroundImage(#imageLiteral(resourceName: "study"), for: .normal)
        button.addTarget(self, action: #selector(goToFlashcardButtonPressed), for: .touchUpInside)
        button.roundCorners(cornerRadius: 10)
        return button
        
    }()
    
    var lessonsButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Lessons", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        button.tintColor = .white
        button.setBackgroundImage(#imageLiteral(resourceName: "classroom"), for: .normal)
        button.addTarget(self, action: #selector(goToLessonButtonPressed), for: .touchUpInside)
        button.roundCorners(cornerRadius: 10)
        return button
        
    }()
    
    // Background Views
    let resultBackgroundView = UIView ()
    
    let addFlashcardBackgroundView = UIView()
    
    let goToFlashcardBackgroundView = UIView()
    
    let lessonBackgroundView = UIView()

//MARK: - Class Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = K.Colors.lightGrey
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupShadows()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateLanguageStackView(searchType: self.searchType)
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
        
        textViewBackgroundView.setShadow(color: UIColor.black, opacity: 0.3, offset: .init(width: 0, height: 3), radius: 2)
        
        resultBackgroundView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        
        addFlashcardBackgroundView.setShadow(color: .black, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 2, cornerRadius: 15)
        
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
        
        // Add userbutton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(profileButtonTapped))
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.Colors.purple

    }
    
    func setupLanguageSelectionView() {
        
        // Add Language Bar View
        view.addSubview(languageBarView)
        
        languageBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                               bottom: nil, leading: view.leadingAnchor,
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
        switch searchType {
        
        case.englishToNative:
            languageButton.setTitle(TranslationManager.shared.targetLanguageName, for: .normal)
            langStackView.addArrangedSubview(englishLabel)
            langStackView.addArrangedSubview(swapButton)
            langStackView.addArrangedSubview(languageButton)
            
        case.nativeToEnglish:
            languageButton.setTitle(TranslationManager.shared.sourceLanguageName, for: .normal)
            langStackView.addArrangedSubview(languageButton)
            langStackView.addArrangedSubview(swapButton)
            langStackView.addArrangedSubview(englishLabel)
        }
    }
    
    func setupTextView() {
        
        // Add View
        view.addSubview(textViewBackgroundView)
        
        textViewBackgroundView.anchor(top: langStackView.bottomAnchor,
                                      bottom: nil,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor,
                                      height: 60,
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
                        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        
        // Add X Button
        view.addSubview(cancelButton)
        
        cancelButton.anchor(top: textView.topAnchor,
                            bottom: nil,
                            leading: nil,
                            trailing: textView.trailingAnchor,
                            height: 40,
                            width: 40,
                            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func setupScrollView() {
        
        // Add scroll view and content view
        view.addSubview(mainScrollView)
        view.sendSubviewToBack(mainScrollView)
        mainScrollView.addSubview(mainContentView)
        
        // Anchor Scroll View
        mainScrollView.anchor(top: textView.bottomAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          height: nil,
                          width: nil)
        
        // Anchor Content View
        mainContentView.anchor(top: mainScrollView.topAnchor,
                           bottom: mainScrollView.bottomAnchor,
                           leading: mainScrollView.leadingAnchor,
                           trailing: mainScrollView.trailingAnchor,
                           height: nil,
                           width: nil)
        
        mainContentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        
        // Setup Results Background
        mainContentView.addSubview(resultBackgroundView)
        
        resultBackgroundView.anchor(top: mainContentView.topAnchor,
                                    bottom: nil,
                                    leading: mainContentView.leadingAnchor,
                                    trailing: mainContentView.trailingAnchor,
                                    height: nil,
                                    width: nil,
                                    padding: UIEdgeInsets(top: 30, left: 20, bottom: -20, right: -20))
        
        // Setup Results Card
        resultBackgroundView.addSubview(resultCardView)
        
        resultCardView.anchor(top: resultBackgroundView.topAnchor,
                              bottom: resultBackgroundView.bottomAnchor,
                              leading: resultBackgroundView.leadingAnchor,
                              trailing: resultBackgroundView.trailingAnchor,
                              height: nil,
                              width: nil)
        
        setupResultsView(resultCardView)
        
        // Setup Alternative Translations Scroll View
        setupAlternativeTranslationScrollView()
        
        // Setup Learn More Scroll View
        setupLearnMoreScrollView()
        
        // Setup FlashCard UpSaleButton
        setupGoToFlashcardsButton()
        
        // Setup Lessons UpSaleButton
        setupLessonsButton()
    
    }
    
    func setupResultsView(_ resultCardView: UIView) {
        
        // Configure Top Label
        let topAttributedText = NSMutableAttributedString()
        
        for i in 0..<results.count {
            
            topAttributedText.append(results[i].attributedText)
            
            if i != results.count - 1 {
                topAttributedText.append(NSAttributedString(string: " "))
            }
        }
        
        topLabel.attributedText = topAttributedText
        topLabel.configureBasedOnInput()
        topLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(wildCardTapped(_:))))
        
        // Configure Bottom Label
        
        bottomLabel.attributedText = NSAttributedString(string: bottomLabelText)
        bottomLabel.configureBottomLabel()
        
        // Add Flashcard Button to its Background View
        addFlashcardBackgroundView.addSubview(addFlashcardButton)
        
        addFlashcardButton.anchor(top: addFlashcardBackgroundView.topAnchor,
                                  bottom: addFlashcardBackgroundView.bottomAnchor,
                                  leading: addFlashcardBackgroundView.leadingAnchor,
                                  trailing: addFlashcardBackgroundView.trailingAnchor,
                                  height: nil,
                                  width: nil)
        
        // Setup Collection View
        setupCollectionView()
        
        // Add subviews to Result Card
        resultCardView.addSubview(topLabel)
        resultCardView.addSubview(bottomLabel)
        resultCardView.addSubview(soundButton)
        resultCardView.addSubview(loopButton)
        resultCardView.addSubview(lineDividerView)
        resultCardView.addSubview(addFlashcardBackgroundView)
        resultCardView.addSubview(soundItOutCollectionView)
        
        // Setup Result Card Layout Constraints for subviews
        setResultViewConstraints(for: searchType)
        
        // Hide Unecessary Views in Result Controller
        updateResultSubviewVisibilities()

    }
    
    func setupCollectionView() {
        
        soundItOutCollectionView.delegate = self
        soundItOutCollectionView.dataSource = self
        soundItOutCollectionView.register(SoundItOutCell.self, forCellWithReuseIdentifier: SoundItOutCell.identifier)
        soundItOutCollectionView.isScrollEnabled = false
    }
    
    func setResultViewConstraints(for searchType: SearchType) {
                
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerYAnchor.constraint(equalTo: resultCardView.centerYAnchor).isActive = true
        lineDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineDividerView.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor).isActive = true
        lineDividerView.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor).isActive = true
        
        loopButton.anchor(top: resultCardView.topAnchor,
                          bottom: nil,
                          leading: nil,
                          trailing: resultCardView.trailingAnchor,
                          height: nil,
                          width: nil,
                          padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -10))
        
        soundButton.anchor(top: resultCardView.topAnchor,
                           bottom: nil,
                           leading: nil,
                           trailing: loopButton.leadingAnchor,
                           height: nil,
                           width: nil,
                           padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -10))
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.topAnchor.constraint(equalTo: soundButton.bottomAnchor, constant: 27).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor, constant: 0).isActive = true
        topLabel.leadingAnchor.constraint(greaterThanOrEqualTo: resultCardView.leadingAnchor, constant: 10).isActive = true
        topLabel.trailingAnchor.constraint(lessThanOrEqualTo: resultCardView.trailingAnchor, constant: -10).isActive = true
        
        soundItOutCollectionView.anchor(top: topLabel.bottomAnchor,
                                        bottom: lineDividerView.topAnchor,
                                        leading: resultCardView.leadingAnchor,
                                        trailing: resultCardView.trailingAnchor,
                                        height: nil,
                                        width: nil,
                                        padding: UIEdgeInsets(top: 10, left: 20, bottom: -20, right: -20))

        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.topAnchor.constraint(equalTo: lineDividerView.bottomAnchor, constant: 20).isActive = true
        bottomLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor, constant: 0).isActive = true
        bottomLabel.leadingAnchor.constraint(greaterThanOrEqualTo: resultCardView.leadingAnchor, constant: 10).isActive = true
        bottomLabel.trailingAnchor.constraint(lessThanOrEqualTo: resultCardView.trailingAnchor, constant: -10).isActive = true
        
        addFlashcardBackgroundView.anchor(top: bottomLabel.bottomAnchor,
                                          bottom: resultCardView.bottomAnchor,
                                          leading: nil,
                                          trailing: resultCardView.trailingAnchor,
                                          height: 30,
                                          width: 30,
                                          padding: UIEdgeInsets(top: 10, left: 0, bottom: -10, right: -10))
        
    }
    
    func updateResultSubviewVisibilities() {
        
        if results.count == 1 {
            
            soundButton.isHidden = false
            loopButton.isHidden = false
            soundItOutCollectionView.isHidden = false
            
        }
        
        else {
            
            soundButton.isHidden = true
            loopButton.isHidden = true
            soundItOutCollectionView.isHidden = true
            
        }
        
    }
    
    func setupAlternativeTranslationScrollView() {
        
        // Add Header Label and Scroll View to the Main Content View
        mainContentView.addSubview(alternativesHeaderLabel)
        mainContentView.addSubview(alternativesScrollView)
        
        // Add Stack View to Scroll View
        alternativesScrollView.addSubview(alternativesStackView)
        
        // Anchor Header, Scroll, and Stack  Views
        alternativesHeaderLabel.anchor(top: resultCardView.bottomAnchor,
                                       bottom: nil,
                                       leading: mainContentView.leadingAnchor,
                                       trailing: mainContentView.trailingAnchor,
                                       height: nil, width: nil,
                                       padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        
    
        
        alternativesScrollView.anchor(top: alternativesHeaderLabel.bottomAnchor,
                                      bottom: nil,
                                      leading: mainContentView.leadingAnchor,
                                      trailing: mainContentView.trailingAnchor,
                                      height: nil,
                                      width: nil,
                                      padding: UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20))

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
            let myButton = UIButton()
            myButton.backgroundColor = .clear
            myButton.addTarget(self, action: #selector(alternativesButtonPressed), for: .touchUpInside)
            
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
        mainContentView.addSubview(learnMoreHeaderLabel)
        mainContentView.addSubview(learnMoreScrollView)
        
        // Add Stack View to Scroll View
        learnMoreScrollView.addSubview(learnMoreStackView)
        
        // Anchor Header, Scroll, and Stack  Views
        learnMoreHeaderLabel.anchor(top: alternativesScrollView.bottomAnchor,
                                       bottom: nil,
                                       leading: mainContentView.leadingAnchor,
                                       trailing: mainContentView.trailingAnchor,
                                       height: nil, width: nil,
                                       padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20))
        
       learnMoreScrollView.anchor(top: learnMoreHeaderLabel.bottomAnchor,
                                      bottom: nil,
                                      leading: mainContentView.leadingAnchor,
                                      trailing: mainContentView.trailingAnchor,
                                      height: nil,
                                      width: nil,
                                      padding: UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20))
        
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
        
        let words = ["great", "job", "that", "was", "congratulations"]
        
        for word in words {
            
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
            let attText = NSMutableAttributedString(string: word)
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
            let myButton = UIButton()
            myButton.backgroundColor = .clear
            myButton.addTarget(self, action: #selector(learnMoreButtonPressed), for: .touchUpInside)
            
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
        
        mainContentView.addSubview(goToFlashcardBackgroundView)
        goToFlashcardBackgroundView.addSubview(goToFlashcardsButton)
        
        goToFlashcardBackgroundView.anchor(top: learnMoreScrollView.bottomAnchor,
                                           bottom: nil,
                                           leading: mainContentView.leadingAnchor,
                                           trailing: mainContentView.trailingAnchor,
                                           height: 120,
                                           width: nil,
                                           padding: UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20))
        
        goToFlashcardsButton.anchor(top: goToFlashcardBackgroundView.topAnchor,
                                    bottom: goToFlashcardBackgroundView.bottomAnchor,
                                    leading: goToFlashcardBackgroundView.leadingAnchor,
                                    trailing: goToFlashcardBackgroundView.trailingAnchor,
                                    height: nil,
                                    width: nil)
    }
    
    func setupLessonsButton() {
        
        mainContentView.addSubview(lessonBackgroundView)
        lessonBackgroundView.addSubview(lessonsButton)
        
        lessonBackgroundView.anchor(top: goToFlashcardBackgroundView.bottomAnchor,
                                    bottom: mainContentView.bottomAnchor,
                                    leading: mainContentView.leadingAnchor,
                                    trailing: mainContentView.trailingAnchor,
                                    height: 240,
                                    width: nil,
                                    padding: UIEdgeInsets(top: 20, left: 20, bottom: -40, right: -20))
        
        lessonsButton.anchor(top: lessonBackgroundView.topAnchor,
                             bottom: lessonBackgroundView.bottomAnchor,
                             leading: lessonBackgroundView.leadingAnchor,
                             trailing: lessonBackgroundView.trailingAnchor,
                             height: nil,
                             width: nil)
        
    }
    
    //MARK:- Selector Functions
    
    @objc func profileButtonTapped() {
        print(0)
    }
    
    @objc func languageButtonPressed() {
        
        let supportedLanguagesVC = SupportedLanguagesVC()
        supportedLanguagesVC.delegate = self
        supportedLanguagesVC.searchType = self.searchType
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
            switch self.searchType {
                
            case .englishToNative:
                self.searchType = .nativeToEnglish
                
            case .nativeToEnglish:
                self.searchType = .englishToNative
                
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
        let tempSourceCode = TranslationManager.shared.sourceLanguageCode
        TranslationManager.shared.sourceLanguageCode = TranslationManager.shared.targetLanguageCode
        TranslationManager.shared.targetLanguageCode = tempSourceCode
        
        let tempSourceName = TranslationManager.shared.sourceLanguageName
        TranslationManager.shared.sourceLanguageName = TranslationManager.shared.targetLanguageName
        TranslationManager.shared.targetLanguageName = tempSourceName
        
    }
    
    @objc func cancelButtonPressed() {
        textView.text = ""
        textView.textColor = .lightGray
        textView.text = "Enter text"
        cancelButton.isHidden = true
    }
    
    @objc func soundButtonPressed(_ sender: UIButton) {
        
        if let soundURL = results[sender.tag].audioString {
            
            playAudioFile(urlString: soundURL, loop: 0)
            
        }
        
    }
    
    @objc func loopButtonPressed(_ sender: UIButton) {
        
        if let soundURL = results[sender.tag].audioString {
            
            playAudioFile(urlString: soundURL, loop: 5)
            
        }
    }
    
    @objc func wildCardTapped(_ gesture: UITapGestureRecognizer) {
        
        guard let index = gesture.indexForTapAttributedTextInLabel(label: self.topLabel) else { return }
        
        guard let linkNumber = topLabel.attributedText?.attribute(.linkNumber, at: index, effectiveRange: nil) as? String else { return }
        guard let color = topLabel.attributedText?.attribute(.foregroundColor, at: index, effectiveRange: nil) as? UIColor else { return }
        
        if color == K.Colors.yellow {
            showPopTip(range: NSRange(location: index, length: 1), linkString: linkNumber)
        }
        
    }
    
    @objc func soundItOutButtonPressed(_ sender: SoundButton) {
        
        switch sender.title(for: .normal) {
        case "i":
            playSound("BEAT")
        case "ɪ":
            playSound("BIT")
        case "ɑ","ɔ":
            playSound("BOT")
        case "u":
            playSound("BOOT")
        case "ʊ":
            playSound("BOOK")
        case "p":
            playSound("P")
        case "v":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("V")
        case "aɪ":
            playSound("BITE")
        case "əl","oʊl","ʊl":
            playSound("DarkL")
        case "ɪr" where sender.backgroundColor == K.Colors.seaBlue:
            playSound("BEAT")
        case "ɪr" where sender.backgroundColor == K.Colors.darkGrey:
            playSound("DarkR")
        case "ks":
            playSound("KS")
        case "ɔɪ":
            playSound("BOYD")
        case "weɪ":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("WEI")
        case "j":
            playSound("Y")
        case "n":
            playSound("N")
        case "t":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("T")
        case "æŋ" where sender.backgroundColor == K.Colors.pink:
            playSound("BAIT")
        case "æŋ" where sender.backgroundColor == K.Colors.darkGrey:
            playSound("NSoft")
        case "eɪ":
            playSound("BAIT")
        case "ər","ʊr":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("DarkR")
        case "ɪŋ" where sender.backgroundColor == K.Colors.seaBlue:
            playSound("BEAT")
        case "ɪŋ" where sender.backgroundColor == K.Colors.darkGrey:
            playSound("NSoft")
        case "h":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("H")
        case "m":
            playSound("M")
        case "ð":
            playSound("TH")
        case "b":
            playSound("B")
        case "dʒ":
            playSound("JOKE")
        case "ɡz":
            playSound("GZ")
        case "ju":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("YOU")
        case "oʊ":
            playSound("BOAT")
        case "tʃ":
            playSound("CHOKE")
        case "f":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("F")
        case "l":
            playSound("L")
        case "d":
            playSound("D")
        case "θ":
            playSound("THunvoiced")
        case "ɑr" where sender.backgroundColor == K.Colors.green:
            playSound("BOT")
        case "ɑr" where sender.backgroundColor == K.Colors.darkGrey:
            playSound("DarkR")
        case "ɛr" where sender.backgroundColor == K.Colors.darkGreen:
            playSound("BET")
        case "ɛr" where sender.backgroundColor == K.Colors.darkGrey:
            playSound("DarkR")
        case "kw":
            playSound("Q")
        case "ɔr" where sender.backgroundColor == K.Colors.purple:
            playSound("BOAT")
        case "ʔ":
            break
        case "ɡ":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("G")
        case "r":
            playSound("R")
        case "z":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("Z")
        case "aʊ":
            playSound("BOUT")
        case "ɛŋ" where sender.backgroundColor == K.Colors.pink:
            playSound("BAIT")
        case "ɛŋ" where sender.backgroundColor == K.Colors.darkGrey:
            playSound("NSoft")
        case "jə":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("YUH")
        case "kʃ":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("KSH")
        case "wə":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("WUH")
        case "wɪ":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("WIH")
        case "k":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("K")
        case "ŋ":
            playSound("NSoft")
        case "s":
            playSound("S")
        case "ʃ":
            playSound("MISSION")
        case "w":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                   let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            playSound("W")
        case "ʒ":
            playSound("VISION")
        case "æ":
            playSound("BAT")
        case "ə":
            playSound("BUT")
        case "ɛ":
            playSound("BET")
        default:
            break
        }
    }
    
    @objc func addFlashcardButtonPressed() {
        print("adding flashcard")
    }
    
    @objc func alternativesButtonPressed() {
        print("searching alternative")
    }
    
    @objc func learnMoreButtonPressed() {
        print("learn more")
    }
    
    @objc func goToFlashcardButtonPressed() {
        print("go to flashcards")
    }
    
    @objc func goToLessonButtonPressed() {
        print("going to lessons")
    }
}

//MARK:- UITextView Delegate Methods

extension ResultsController: UITextViewDelegate {
    
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
            textView.resignFirstResponder()
            
            // Perform Search
            startSearchSequence()
            
            return false
        }
        return true
    }
    
}

//MARK: - Collection View Data Source Methods
extension ResultsController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return soundItOutColors.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = soundItOutCollectionView.dequeueReusableCell(withReuseIdentifier: SoundItOutCell.identifier, for: indexPath) as! SoundItOutCell
        let colorInfo = soundItOutColors[indexPath.row]
        
        cell.soundButton.backgroundColor = colorInfo.color
        cell.soundButton.setTitle(colorInfo.ID, for: .normal)
        cell.soundButton.addTarget(self, action: #selector(soundItOutButtonPressed(_:)), for: .touchUpInside)
        
        if colorInfo.color == K.Colors.yellow {
            
            cell.soundButton.wildRange = colorInfo.range
            
        }
        
        return cell
        
    }
    
}

//MARK: - Collection View Delegate Flow Layout Methods
extension ResultsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 35, height: 35)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // Centers the collection view when there is only a single row
        let num = CGFloat(soundItOutCollectionView.numberOfItems(inSection: 0))
        let width = soundItOutCollectionView.frame.width
        
        if num <= 8 {
            let totalExtraSpace = width - (num*35.0 + (num - 1.0)*3.0)
            return UIEdgeInsets(top: 0, left: totalExtraSpace/2.0, bottom: 0, right: totalExtraSpace/2.0)
        }
        
        return UIEdgeInsets.zero
    }
}

//MARK:- Language Selection Functions

extension ResultsController: SupportedLanguagesDelegate  {
    
    func updateLanguageButton(selectedLanguage: TranslationLanguage) {
        
        languageButton.setTitle(selectedLanguage.name, for: .normal)
        
    }    
}

// MARK:- Search Sequence Functions

extension ResultsController {
    
    func startSearchSequence() {
        
        // Clear Results Array
        results = []
        
        // Make sure textView is not Empty
        if textView.text != nil && textView.text.count > 0 {
            
            // Start Loading Screen
            DispatchQueue.main.async {
                self.startLoadingScreen()
            }
            
            // translate and populate wordModelArray and alternatives array, then color words
            runSearchsequence(searchText: textView.text!) { (success) in
                
                if success {
                    
                    // Populate Results Array
                    for (word,wordModel) in zip(self.wordArray, self.wordModelArray) {
                        
                        // If  Word Model Exists, addg colored word and audio to result
                        if let wordModel = wordModel {
                            
                            // Take only the first ipa spelling for now
                            if let ipa = wordModel.ipa[0] {
                                
                                let audio = (0 < wordModel.audio.count ? wordModel.audio[0] : nil)
                                var text = WordColoringManager.shared.colorWord(word: wordModel.id, ipa: ipa)
                                text = text.setCapitalLetters(from: word)
                                self.results.append(ColorResultModel(attributedText: text, audioString: audio, ipa: ipa, isColored: true))
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
                        self.updateResultsVC()
                    }
                }
                
                // If search sequence not successful (no words found in database) alert to check spelling and internet
                else {
                    let alert = UIAlertController(title: "oops! something went wrong", message: "Check spelling or internet connection", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        return // do nothing
                    }))
                    DispatchQueue.main.async {
                        self.endLoadingScreen()
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func runSearchsequence(searchText: String, completion: @escaping(_ success: Bool) -> Void) {
        
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
    
    func updateResultsVC() {
        
        // Update Views in Results VC
        
    }
}

//MARK:- Utility Functions

extension ResultsController {
    
    func playAudioFile(urlString: String, loop: Int) {
        
        var count = 0
        
        guard let url = URL.init(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)) else { return }
        
        let playerItem = AVPlayerItem.init(url: url)
        
        player = AVPlayer.init(playerItem: playerItem)
        player?.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem,
                                               queue: .main)
        { [weak self] _ in
            
            if count < (loop - 1) {
                
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
                count += 1
                
            }
        }
    }
    
    func playSound(_ soundFileName: String) {
        guard let url = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            soundItOutPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
    
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = soundItOutPlayer else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func showPopTip(range : NSRange, linkString: String) {
        
        guard let rectForRange = self.topLabel.boundingRect(forCharacterRange: range),
              let actualPronunciation = K.linkToWildCardDictionary[linkString]
              else { return }
        
        actualPronunciation.addAttribute(.font,
                                         value: UIFont(name: "Arial-BoldMT", size: 30)!,
                                         range: NSRange(location: 0, length: actualPronunciation.length))
    
        if range == prevRange && popTip.isVisible {
            
            popTip.hide()
            
            prevRange = nil
            
        }
                    
        else {
            
            popTip.show(attributedText: actualPronunciation, direction: .up, maxWidth: 400, in: self.topLabel, from: rectForRange)
            
            prevRange = range
            
        }
    }
}
