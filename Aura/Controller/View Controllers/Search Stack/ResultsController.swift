//
//  ResultsController.swift
//  Aura
//
//  Created by Max Dolensky on 7/9/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class ResultsController: UIViewController {
    
//MARK: - Data
    
    var query = ""
    var queryResult = ""
    
    var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.roundCorners(cornerRadius: 8)
        button.backgroundColor = .purple
        return button
    }()
    
    var soundItOutButtons = [UIButton]()
    
//MARK: - Info
    
    let cellID = "SoundItOutCell"
    
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
        button.setTitle("Japanese", for: .normal)
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
        label.text = "English"
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
    
    var topLabel = UILabel()
    
    var bottomLabel = UILabel()
    
    var soundButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.3.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(soundButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    var loopButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(loopButtonPressed), for: .touchUpInside)
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
       
        // Add Language Button
        langStackView.addArrangedSubview(languageButton)
        
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
        
        // Setup FlashCard UpSaleButton
        setupGoToFlashcardsButton()
        
        // Setup Lessons UpSaleButton
        setupLessonsButton()
        
    }
    
    func setupResultsView(_ resultCardView: UIView) {
        
        // Incoming search and result
        let searchType = SearchType.nativeToEnglish
        let searchInput = "こんにちは"
        let searchOutput = "Hello"
        
        // Configure Top Label
        topLabel.attributedText = NSAttributedString(string: searchInput)
        topLabel.configureBasedOnInput()
        
        // Configure Bottom Label
        bottomLabel.attributedText = NSAttributedString(string: searchOutput)
        bottomLabel.configureBasedOnInput()
        
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

    }
    
    func setupCollectionView() {
        
        soundItOutCollectionView.delegate = self
        soundItOutCollectionView.dataSource = self
        soundItOutCollectionView.register(SoundItOutCell.self, forCellWithReuseIdentifier: SoundItOutCell.identifier)
        soundItOutCollectionView.isScrollEnabled = false
    }
    
    func setResultViewConstraints(for searchType: SearchType) {
    
        switch searchType {
        
        case .nativeToEnglish:
            
            lineDividerView.translatesAutoresizingMaskIntoConstraints = false
            lineDividerView.centerYAnchor.constraint(equalTo: resultCardView.centerYAnchor).isActive = true
            lineDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            lineDividerView.leadingAnchor.constraint(equalTo: resultCardView.leadingAnchor).isActive = true
            lineDividerView.trailingAnchor.constraint(equalTo: resultCardView.trailingAnchor).isActive = true
            
            topLabel.translatesAutoresizingMaskIntoConstraints = false
            topLabel.topAnchor.constraint(equalTo: resultCardView.topAnchor, constant: 10).isActive = true
            topLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor, constant: 0).isActive = true
            topLabel.leadingAnchor.constraint(greaterThanOrEqualTo: resultCardView.leadingAnchor, constant: 10).isActive = true
            topLabel.trailingAnchor.constraint(lessThanOrEqualTo: resultCardView.trailingAnchor, constant: -10).isActive = true
            topLabel.bottomAnchor.constraint(equalTo: lineDividerView.topAnchor, constant: -10).isActive = true
            
            loopButton.anchor(top: lineDividerView.bottomAnchor,
                              bottom: nil,
                              leading: nil,
                              trailing: resultCardView.trailingAnchor,
                              height: nil,
                              width: nil,
                              padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -10))
            
            soundButton.anchor(top: lineDividerView.bottomAnchor,
                               bottom: nil,
                               leading: nil,
                               trailing: loopButton.leadingAnchor,
                               height: nil,
                               width: nil,
                               padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -10))
            
            bottomLabel.translatesAutoresizingMaskIntoConstraints = false
            bottomLabel.topAnchor.constraint(equalTo: soundButton.bottomAnchor, constant: 10).isActive = true
            bottomLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor, constant: 0).isActive = true
            bottomLabel.leadingAnchor.constraint(greaterThanOrEqualTo: resultCardView.leadingAnchor, constant: 10).isActive = true
            bottomLabel.trailingAnchor.constraint(lessThanOrEqualTo: resultCardView.trailingAnchor, constant: -10).isActive = true
            
            soundItOutCollectionView.anchor(top: bottomLabel.bottomAnchor,
                                            bottom: nil,
                                            leading: resultCardView.leadingAnchor,
                                            trailing: resultCardView.trailingAnchor,
                                            height: nil,
                                            width: nil,
                                            padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: -20))
            
            
            addFlashcardBackgroundView.anchor(top: soundItOutCollectionView.bottomAnchor,
                                              bottom: resultCardView.bottomAnchor,
                                              leading: nil,
                                              trailing: resultCardView.trailingAnchor,
                                              height: 30,
                                              width: 30,
                                              padding: UIEdgeInsets(top: 10, left: 0, bottom: -10, right: -10))
        case .englishToNative:
            
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
            topLabel.topAnchor.constraint(equalTo: soundButton.bottomAnchor, constant: 10).isActive = true
            topLabel.centerXAnchor.constraint(equalTo: resultCardView.centerXAnchor, constant: 0).isActive = true
            topLabel.leadingAnchor.constraint(greaterThanOrEqualTo: resultCardView.leadingAnchor, constant: 10).isActive = true
            topLabel.trailingAnchor.constraint(lessThanOrEqualTo: resultCardView.trailingAnchor, constant: -10).isActive = true
            
            soundItOutCollectionView.anchor(top: topLabel.bottomAnchor,
                                            bottom: lineDividerView.topAnchor,
                                            leading: resultCardView.leadingAnchor,
                                            trailing: resultCardView.trailingAnchor,
                                            height: nil,
                                            width: nil,
                                            padding: UIEdgeInsets(top: 10, left: 20, bottom: -10, right: -20))

            bottomLabel.translatesAutoresizingMaskIntoConstraints = false
            bottomLabel.topAnchor.constraint(equalTo: lineDividerView.bottomAnchor, constant: 10).isActive = true
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
        
        let altTranslations = ["great job", "amazing", "you are an incredible person"]
        
        for alt in altTranslations {
            
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
    
    func setupGoToFlashcardsButton() {
        
        mainContentView.addSubview(goToFlashcardBackgroundView)
        goToFlashcardBackgroundView.addSubview(goToFlashcardsButton)
        
        goToFlashcardBackgroundView.anchor(top: alternativesScrollView.bottomAnchor,
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
    
    @objc func soundButtonPressed() {
        print("soundButton")
    }
    
    @objc func loopButtonPressed() {
        print("loopButton")
    }
    
    @objc func addFlashcardButtonPressed() {
        print("adding flashcard")
    }
    
    @objc func alternativesButtonPressed() {
        print("searching alternative")
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
            // Perform Search
            return false
        }
        return true
    }
}

//MARK: - Collection View Data Source Methods
extension ResultsController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = soundItOutCollectionView.dequeueReusableCell(withReuseIdentifier: SoundItOutCell.identifier, for: indexPath) as! SoundItOutCell
        
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
