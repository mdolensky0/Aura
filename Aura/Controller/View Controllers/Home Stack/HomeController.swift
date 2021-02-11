//
//  HomeViewController.swift
//  Aura
//
//  Created by Max Dolensky on 7/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    var mainScrollView = VerticalScrollView(frame: .zero)
    
    var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        label.backgroundColor = .clear
        label.font = UIFont(name: K.Fonts.avenirBlack, size: 17)
        label.text = "Aura"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
        
    var discoverEHDView: UIView = {
        
        let container = UIView()
        
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Discover")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        iv.roundCorners(cornerRadius: 20)
        
        container.addSubview(iv)
        iv.anchor(top: container.topAnchor,
                      bottom: container.bottomAnchor,
                      leading: container.leadingAnchor,
                      trailing: container.trailingAnchor,
                      height: nil,
                      width: nil)
        
        let b = AnimatedButton(frame: .zero)
        b.addTarget(self, action: #selector(discoverPressed(_:)), for: .touchUpInside)
        
        container.addSubview(b)
        b.anchor(top: container.topAnchor,
                 bottom: container.bottomAnchor,
                 leading: container.leadingAnchor,
                 trailing: container.trailingAnchor,
                 height: nil,
                 width: nil)
        
        return container
        
    }()
    
    var whereToStartLabel: UILabel = {
        
        let l = UILabel()
        l.text = "Where to start"
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.textColor = .black
        return l
        
    }()
    
    var searchView: UIView = {
        
        let background = UIView()
        
        let container = UIView()
        container.backgroundColor = .white
        
        let l = UILabel()
        l.text = "Search"
        l.textAlignment = .left
        l.textColor = K.DesignColors.primary
        l.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        let iv = UIImageView()
        
        if #available(iOS 13, *) {
            iv.image = UIImage(systemName: "magnifyingglass")
        } else {
            iv.image = #imageLiteral(resourceName: "Search1").withRenderingMode(.alwaysTemplate)
        }
        
        iv.tintColor = K.DesignColors.primary
        
        iv.contentMode = .scaleAspectFit
                
        container.addSubview(l)
        container.addSubview(iv)
        
        l.anchor(top: container.topAnchor,
                 bottom: container.bottomAnchor,
                 leading: container.leadingAnchor,
                 trailing: nil,
                 height: nil,
                 width: nil,
                 padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iv.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
        iv.centerYAnchor.constraint(equalTo: l.centerYAnchor).isActive = true
        
        background.addSubview(container)
        
        container.anchor(top: background.topAnchor,
                         bottom: background.bottomAnchor,
                         leading: background.leadingAnchor,
                         trailing: background.trailingAnchor,
                         height: nil,
                         width: nil)
        
        container.roundCorners(cornerRadius: 10)
        
        let b = AnimatedButton(frame: .zero)
        b.addTarget(self, action: #selector(searchPressed(_:)), for: .touchUpInside)
        
        background.addSubview(b)
        b.anchor(top: background.topAnchor,
                 bottom: background.bottomAnchor,
                 leading: background.leadingAnchor,
                 trailing: background.trailingAnchor,
                 height: nil,
                 width: nil)
        
        return background
        
    }()
    
    var introImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var introVideoView: UIView = {
        
        let container = UIView()
        
        let play = UIImageView()
        play.backgroundColor = .white
        
        if #available(iOS 13, *) {
            play.image = UIImage.init(systemName: "play.fill")
        } else {
            play.image = #imageLiteral(resourceName: "play.fill").withRenderingMode(.alwaysTemplate)
        }
        
        play.tintColor = K.DesignColors.primary
        play.backgroundColor = UIColor(white: 0.8, alpha: 0.4)
        play.roundCorners(cornerRadius: 30)
        play.contentMode = .center
        
        play.translatesAutoresizingMaskIntoConstraints = false
        play.heightAnchor.constraint(equalToConstant: 60).isActive = true
        play.widthAnchor.constraint(equalToConstant: 60).isActive = true
        play.alpha = 0.7
        

        
        container.addSubview(introImageView)
        
        introImageView.anchor(top: container.topAnchor,
                  bottom: container.bottomAnchor,
                  leading: container.leadingAnchor,
                  trailing: container.trailingAnchor,
                  height: nil,
                  width: nil)
    
        introImageView.roundCorners(cornerRadius: 10)
        
        container.addSubview(play)
        
        play.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        play.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        let b = AnimatedButton(frame: .zero)
        b.addTarget(self, action: #selector(introVideoPressed(_:)), for: .touchUpInside)
        
        container.addSubview(b)
        b.anchor(top: container.topAnchor,
                 bottom: container.bottomAnchor,
                 leading: container.leadingAnchor,
                 trailing: container.trailingAnchor,
                 height: nil,
                 width: nil)
        
        return container
        
    }()
    
    var popularFlashcardLabel: UILabel = {
        
        let l = UILabel()
        l.text = "Popular Flashcards"
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.textColor = .black
        return l
        
    }()
    
    var popularFlashcardScrollView: PopularDecksScrollView!
    
    var lessonsLabel: UILabel = {
        
        let l = UILabel()
        l.text = "Lessons"
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.textColor = .black
        return l
        
    }()
    
    var lessonsScrollView = LessonsScrollView(frame: .zero)
    
    var myDecksLabel: UILabel = {
        
        let l = UILabel()
        l.text = "My Decks"
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.textColor = .black
        return l
        
    }()
    
    var myDecksScrollView: MyDecksScrollView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //getMatches(for: "ɪ", letterCombo: "oi")
        
        // FOR TESTING
        AdManager.shared.funnelProgress = .hasNotSeenVideo1
        UserDefaults.standard.set(false, forKey: "hasLaunchedHome")
        UserDefaults.standard.setValue(0, forKey: "currentLessonNum")
        UserDefaults.standard.setValue(5, forKey: "searchCount")
        UserDefaults.standard.setValue(false, forKey: "hasEnteredDeckController")
        UserDefaults.standard.set(false, forKey: "hasLaunchedFlashcards")
        UserDefaults.standard.set(false, forKey: "hasSeenDeckSelector")
    }
    
    override func viewDidLayoutSubviews() {
        
        discoverEHDView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)

        searchView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)

        introVideoView.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 5, cornerRadius: 10)
        
        for v in popularFlashcardScrollView.stackView.subviews {
            v.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
        for v in lessonsScrollView.stackView.subviews {
            v.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
        
        for v in myDecksScrollView.stackView.subviews {
            v.setShadow(color: .black, opacity: 0.3, offset: CGSize(width: 5, height: 5), radius: 2, cornerRadius: 10)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        if UserDefaults.standard.bool(forKey: "hasLaunchedHome") {
            return
        } else {
            
            AdManager.shared.funnelProgress = .hasNotSeenVideo1
            AdManager.shared.showAdPopUP(parentVC: self)
            UserDefaults.standard.set(true, forKey: "hasLaunchedHome")
        }
    }
    
    func setup() {
        
        Utilities.shared.homeDelegate = self
        AdManager.shared.homeDelegate = self
        
        view.backgroundColor = K.DesignColors.background
        
        // Add Center Title
        self.navigationItem.titleView = titleLabel
        
        // Add Settings Button
        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(settingsButtonTapped))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "line.horizontal.3").withRenderingMode(.alwaysTemplate),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(settingsButtonTapped))
        }
        
        // Make bar color purple, and buttons white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = K.DesignColors.primary
        
        // Initialize My Decks Scroll View
        if let decks = Utilities.shared.user?.decks {
            myDecksScrollView = MyDecksScrollView(frame: .zero, decks: decks)
            myDecksScrollView.myDeckDelegate = self
        } else {
            myDecksScrollView = MyDecksScrollView(frame: .zero)
            myDecksScrollView.myDeckDelegate = self
        }
        
        // Initialize Popular Decks Scroll View
        if let decks = Utilities.shared.superUser?.decks {
            popularFlashcardScrollView = PopularDecksScrollView(frame: .zero, decks: decks)
            popularFlashcardScrollView.popularDeckDelegate = self
        } else {
            popularFlashcardScrollView = PopularDecksScrollView(frame: .zero)
            popularFlashcardScrollView.popularDeckDelegate = self
            
            FirebaseManager.shared.loadSuperUser()
        }
        
        // Initialize Lessons Scroll View
        lessonsScrollView.lessonsScrollViewDelegate = self
        if let lessons = Utilities.shared.lessons {
            lessonsScrollView.lessons = lessons
            lessonsScrollView.updateLessons()
        } else {
            FirebaseManager.shared.loadLessons()
        }
        
        view.addSubview(mainScrollView)
        mainScrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              bottom: view.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              height: nil,
                              width: nil)
        
        mainScrollView.stackView.addArrangedSubview(discoverEHDView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(searchView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(whereToStartLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(introVideoView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(popularFlashcardLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(popularFlashcardScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(lessonsLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(lessonsScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(myDecksLabel, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        mainScrollView.stackView.addArrangedSubview(myDecksScrollView, withMargin: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
        
        discoverEHDView.translatesAutoresizingMaskIntoConstraints = false
        discoverEHDView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        introVideoView.translatesAutoresizingMaskIntoConstraints = false
        introVideoView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        introImageView.loadImageUsingCacheWithURLString(urlString: AdManager.shared.getFunnelThumbnailURLForCurrentUserState()) 
        whereToStartLabel.text = AdManager.shared.getFunnelLabelTitleForCurrentUserState()
        
        popularFlashcardScrollView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        lessonsScrollView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        myDecksScrollView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                        
        // Update My Decks Visibility
        myDecksScrollView.updateVisibility()
        if myDecksScrollView.decks.count == 0 {
            myDecksLabel.superview?.isHidden = true
        }
        
        // Update Popular Decks Visibility
        popularFlashcardScrollView.updateVisibility()
        if popularFlashcardScrollView.decks.count == 0 {
            popularFlashcardLabel.superview?.isHidden = true
        }
    }
    
    func populatePopularFlashcards(decks: [DeckModel]) {
                
        for _ in 0...3 {
            
            let background = UIView()
            
            let container = UIView()
            container.backgroundColor = .white
            container.roundCorners(cornerRadius: 10)
            
            background.addSubview(container)
            container.anchor(top: background.topAnchor,
                             bottom: background.bottomAnchor,
                             leading: background.leadingAnchor,
                             trailing: background.trailingAnchor,
                             height: nil,
                             width: nil)
            
            background.translatesAutoresizingMaskIntoConstraints = false
            background.widthAnchor.constraint(equalToConstant: 200).isActive = true
            background.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            
            popularFlashcardScrollView.stackView.addArrangedSubview(background)
            
        }
        
    }
    
    func populateLessons() {
        
        var i = 0
        for lesson in Utilities.shared.lessons! {
            
            let background = UIView()
            
            let container = CustomImageView()
            container.backgroundColor = .white
            container.roundCorners(cornerRadius: 10)
            container.contentMode = .scaleAspectFill
            container.loadImageUsingCacheWithURLString(urlString: lesson.lessonThumbnailURL)
            
            background.addSubview(container)
            container.anchor(top: background.topAnchor,
                             bottom: background.bottomAnchor,
                             leading: background.leadingAnchor,
                             trailing: background.trailingAnchor,
                             height: nil,
                             width: nil)
            
            background.translatesAutoresizingMaskIntoConstraints = false
            background.widthAnchor.constraint(equalToConstant: 200).isActive = true
            background.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            let b = AnimatedButton(frame: .zero)
            b.index = i
            b.addTarget(self, action: #selector(lessonPressed(_:)), for: .touchUpInside)
            
            background.addSubview(b)
            b.anchor(top: background.topAnchor,
                     bottom: background.bottomAnchor,
                     leading: background.leadingAnchor,
                     trailing: background.trailingAnchor,
                     height: nil,
                     width: nil)
            
            lessonsScrollView.stackView.addArrangedSubview(background)
            i += 1
        }
        
        if Utilities.shared.lessons!.count == 0 {
            lessonsLabel.superview?.isHidden = true
            lessonsScrollView.superview?.isHidden = true
        }
        
    }
    
    @objc func discoverPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            
            sender.superview?.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.3
            
        } completion: { (_) in
            
            self.tabBarController?.selectedIndex = 2
            
        }
        
    }
        
    @objc func searchPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            
            sender.superview?.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.3
            
        } completion: { (_) in
            
            self.tabBarController?.selectedIndex = 1
            
        }
         
    }
    
    @objc func lessonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            
            sender.superview?.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.3
            
        } completion: { (_) in
            
            self.tabBarController?.selectedIndex = 4
            
        }
        
    }
                
    @objc func settingsButtonTapped() {
    
        Utilities.shared.settingsLauncher.parentVC = self
        Utilities.shared.settingsLauncher.showSettings()
                
    }
    
    @objc func introVideoPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            
            sender.superview?.transform = .identity
            sender.superview?.layer.shadowOpacity = 0.3
            
        } completion: { (_) in
            
            self.tabBarController?.selectedIndex = 4

            if let vc = self.tabBarController!.viewControllers![4] as? UINavigationController {
                let vc = vc.viewControllers[0] as! LessonsController
                vc.scrollToPage(page: 1, animated: false)
                vc.playVideo()
            }
        }
    }
}

extension HomeController: MyDeckScrollViewDelegate, PopularDeckScrollViewDelegate, LessonsScrollViewDelegate {
    
    func goToDeck(deckIndex: Int) {
        
        self.tabBarController?.selectedIndex = 3
        if let controllers = tabBarController?.viewControllers {
            if let navVC = controllers[3] as? UINavigationController {
                navVC.popToRootViewController(animated: false)
                if let rootVC = navVC.viewControllers[0] as? FlashCardController {
                    rootVC.goToDeck(deckIndex: deckIndex)
                }
                
            }
        }
        
    }
    
    func showPurchasePopUp(deckIndex: Int) {
        print("purchase?")
    }
    
    func goToLesson(lessonIndex: Int) {
        print("going to lesson")
    }
    
}

extension HomeController: FirebaseUpdaterDelegate {
    
    func updateMyDecksDisplay() {
        
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
    
    func updatePopularDecksDisplay() {
        
        guard let decks = Utilities.shared.superUser?.decks else { return }
        
        popularFlashcardScrollView.decks = decks
        popularFlashcardScrollView.updateDecks()
        popularFlashcardScrollView.updateVisibility()
        
        if decks.count == 0 {
            popularFlashcardLabel.superview?.isHidden = true
        } else { popularFlashcardLabel.superview?.isHidden = false }
        
    }
    
    func updateLessonsDisplay() {
        guard let lessons = Utilities.shared.lessons else { return }
        lessonsScrollView.lessons = lessons
        lessonsScrollView.updateLessons()
    }
    
}


// MARK: - Find Specific Letter Combo Matches
extension HomeController {
    
    func getMatches(for ipaLetter: String, letterCombo: String) {
        
        var count = 0
        var arr = [[String]]()
        
        // Get File URL
        guard let fileURL = Bundle.main.url(forResource: "finalWordAndIPA", withExtension: "txt") else {
            return
        }
        
        // Get Contents of File URL
        guard let data = try? String(contentsOf: fileURL) else {
            return
        }
        
        // Break up document line by line
        let lines = data.components(separatedBy: "\n")
        
        for line in lines {
            
            // Get Word And IPA
            let wordAndIPA = line.components(separatedBy: " ")
            
            // Check there is a word and IPA
            if wordAndIPA.count != 2 {
                continue
            }
            
            // Check if ipa and word contains ipaLetter and letterCombo
            if !(wordAndIPA[0].contains(letterCombo) && wordAndIPA[1].contains(ipaLetter)) {
                continue
            }
            
            let wordArray = WordColoringManager.shared.getWordArray(word: wordAndIPA[0], ipa: wordAndIPA[1])
            let indices = wordAndIPA[0].indicesOf(string: letterCombo)
            
            for index in indices {
                var isMatch = true
                for i in index..<(index + letterCombo.count) {
                    if wordArray[i].ipaParent != ipaLetter {
                        isMatch = false
                    }
                }
                if isMatch {
                    arr.append(wordAndIPA)
                    count += 1
                }
            }
        }
        
        arr.sort {
            $0[0].count < $1[0].count
        }
        
        print("\n\n----------RESULTS----------\n")
        print("Number of Matches Found: \(count)\n")
        
        for wordAndIpa in arr {
            print(wordAndIpa[0], wordAndIpa[1])
        }
    }
}


// MARK: - AdManagerDelegate
extension HomeController: AdManagerDelegate {
    
    func updateSecretsThumbnail() {
        introImageView.loadImageUsingCacheWithURLString(urlString: AdManager.shared.getFunnelThumbnailURLForCurrentUserState())
        whereToStartLabel.text = AdManager.shared.getFunnelLabelTitleForCurrentUserState()
    }
    
}
