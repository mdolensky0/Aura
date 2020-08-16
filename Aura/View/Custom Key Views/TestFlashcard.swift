//
//  ResultCard.swift
//  Aura
//
//  Created by Max Dolensky on 8/6/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import AVFoundation
import AMPopTip

class TestFlashcard: UIView {
    
    // DATA
    var results = [ColorResultModel]()
    var bottomLabelText = ""
    var soundItOutColors = [(color: UIColor, ID: String, range: NSRange)]()
    
    // INFO
    let popTip: PopTip =  {
        
        let popTip = PopTip()
        popTip.shouldDismissOnTap = true
        popTip.bubbleColor = .white
        popTip.borderColor = .black
        popTip.borderWidth = 1.0
        return popTip
        
    }()
    
    var prevRange: NSRange?
    var delegate: ResultCardDelegate?
    
    // SUBVIEWS
    var mainStackView: UIStackView = {
        
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.backgroundColor = .white
        return view
        
    }()
    
    var topLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .white
        label.clipsToBounds = false
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byWordWrapping
        label.baselineAdjustment = .none
        return label
        
    }()
    
    var bottomLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .white
        return label
        
    }()
    
    var audioStackView: UIStackView = {
        
        let view = UIStackView()
        view.backgroundColor = .white
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 12
        return view
        
    }()
    
    var soundButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.3.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(soundButtonPressed(_:)), for: .touchUpInside)
        return button
        
    }()
    
    var loopButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(loopButtonPressed(_:)), for: .touchUpInside)
        return button
        
    }()
    
    var soundItOutCollectionView: UICollectionView = {
        
        let cv = DynamicCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        return cv
        
    }()
    
    let topLabelContainer = UIView()
    let bottomLabelContainer = UIView()
    
    let spacer1: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
        
    }()

    let spacer2: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect, results: [ColorResultModel], bottomLabelText: String, soundItOutColors: [(color: UIColor, ID: String, range: NSRange)], delegate: ResultCardDelegate? = nil) {
        
        self.init(frame: frame)
        
        self.results = results
        self.bottomLabelText = bottomLabelText
        self.soundItOutColors = soundItOutColors
        self.delegate = delegate
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        
        self.isUserInteractionEnabled = true
        self.addSubview(mainStackView)
        mainStackView.anchor(top: self.topAnchor,
                             bottom: self.bottomAnchor,
                             leading: self.leadingAnchor,
                             trailing: self.trailingAnchor,
                             height: nil,
                             width: nil,
                             padding: UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20))
        
        // Configure Self
        self.backgroundColor = .white
        self.roundCorners(cornerRadius: 10)
        
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
        
        topLabelContainer.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.centerXAnchor.constraint(equalTo: topLabelContainer.centerXAnchor).isActive = true
        topLabel.widthAnchor.constraint(lessThanOrEqualTo: topLabelContainer.widthAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: topLabelContainer.topAnchor).isActive = true
        topLabel.bottomAnchor.constraint(equalTo: topLabelContainer.bottomAnchor).isActive = true
        
        // Configure Bottom Label
        bottomLabel.attributedText = NSAttributedString(string: bottomLabelText)
        bottomLabel.configureBottomLabel()
        
        bottomLabelContainer.addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.centerXAnchor.constraint(equalTo: bottomLabelContainer.centerXAnchor).isActive = true
        bottomLabel.widthAnchor.constraint(lessThanOrEqualTo: bottomLabelContainer.widthAnchor).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: bottomLabelContainer.topAnchor).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: bottomLabelContainer.bottomAnchor).isActive = true
        
        // Setup Collection View
        setupCollectionView()
        
        // Configure Audio Stack View
        let spacer = UIView()
        spacer.backgroundColor = .white
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        soundButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        loopButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        audioStackView.addArrangedSubview(spacer)
        audioStackView.addArrangedSubview(soundButton)
        audioStackView.addArrangedSubview(loopButton)
        
        // Add subviews to Result Card
        mainStackView.addArrangedSubview(audioStackView)
        mainStackView.addArrangedSubview(topLabelContainer)
        mainStackView.addArrangedSubview(soundItOutCollectionView)
        mainStackView.addArrangedSubview(spacer1)
        mainStackView.addArrangedSubview(spacer2)
        mainStackView.addArrangedSubview(bottomLabelContainer)
                
    }
    
    func setupCollectionView() {
        
        soundItOutCollectionView.delegate = self
        soundItOutCollectionView.dataSource = self
        soundItOutCollectionView.register(SoundItOutCell.self, forCellWithReuseIdentifier: SoundItOutCell.identifier)
        soundItOutCollectionView.isScrollEnabled = false
    }
    
    func updateViews() {
        
        // Update Top Label
        let topAttributedText = NSMutableAttributedString()
        
        for i in 0..<results.count {
            
            topAttributedText.append(results[i].attributedText)
            
            if i != results.count - 1 {
                topAttributedText.append(NSAttributedString(string: " "))
            }
        }
        
        topLabel.attributedText = topAttributedText
        topLabel.configureBasedOnInput()
        
        // Update Bottom Label
        bottomLabel.attributedText = NSAttributedString(string: bottomLabelText)
        bottomLabel.configureBottomLabel()
        
        // Update Collection View
        soundItOutCollectionView.reloadData()
        
    }
    
    func updateSubviewVisibilities(isFront: Bool) {
        
        popTip.hide()
        
        // Front : colored word, sound bits and audio buttons
        if isFront {
            
            // Update top and bottom label visibilities
            topLabelContainer.isHidden = false
            bottomLabelContainer.isHidden = true
            
            // Update audio and collection view visibilities
            if results.count == 1 {
                
                if results[0].audioString != nil {
                    audioStackView.isHidden = false
                }
                    
                else {
                    audioStackView.isHidden = true
                }
                
                soundItOutCollectionView.isHidden = false
                spacer1.isHidden = false
                spacer2.isHidden = false
                
            }
                
            else {
                
                audioStackView.isHidden = true
                soundItOutCollectionView.isHidden = true
                spacer1.isHidden = true
                spacer2.isHidden = true
                
            }
            
        }
        
        // Back : bottom label only
        else {
            
            topLabelContainer.isHidden = true
            audioStackView.isHidden = true
            soundItOutCollectionView.isHidden = true
            bottomLabelContainer.isHidden = false
            spacer1.isHidden = true
            spacer2.isHidden = true
            
        }
    }
    
    //MARK: - Selector Functions
    
    @objc func soundButtonPressed(_ sender: UIButton) {
        
        if let soundURL = results[sender.tag].audioString {
            
            Utilities.shared.playAudioFile(urlString: soundURL, loop: 0, sender: sender)
            
        }
        
    }
    
    @objc func loopButtonPressed(_ sender: UIButton) {
        
        
        if Utilities.shared.player != nil {
            print("playing")
            sender.tintColor = .black
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            Utilities.shared.player!.pause()
            Utilities.shared.player = nil
        }
            
        else {
            print("not playing")
            if let soundURL = results[sender.tag].audioString {
                
                Utilities.shared.playAudioFile(urlString: soundURL, loop: 5, sender: sender)
                
            }
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
            Utilities.shared.playSound("BEAT")
        case "ɪ":
            Utilities.shared.playSound("BIT")
        case "ɑ","ɔ":
            Utilities.shared.playSound("BOT")
        case "u":
            Utilities.shared.playSound("BOOT")
        case "ʊ":
            Utilities.shared.playSound("BOOK")
        case "p":
            Utilities.shared.playSound("P")
        case "v":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("V")
        case "aɪ":
            Utilities.shared.playSound("BITE")
        case "əl","oʊl","ʊl":
            Utilities.shared.playSound("DarkL")
        case "ɪr" where sender.backgroundColor == K.Colors.seaBlue:
            Utilities.shared.playSound("BEAT")
        case "ɪr" where sender.backgroundColor == K.Colors.darkGrey:
            Utilities.shared.playSound("DarkR")
        case "ks":
            Utilities.shared.playSound("KS")
        case "ɔɪ":
            Utilities.shared.playSound("BOYD")
        case "weɪ":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("WEI")
        case "j":
            Utilities.shared.playSound("Y")
        case "n":
            Utilities.shared.playSound("N")
        case "t":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("T")
        case "æŋ" where sender.backgroundColor == K.Colors.pink:
            Utilities.shared.playSound("BAIT")
        case "æŋ" where sender.backgroundColor == K.Colors.darkGrey:
            Utilities.shared.playSound("NSoft")
        case "eɪ":
            Utilities.shared.playSound("BAIT")
        case "ər","ʊr":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("DarkR")
        case "ɪŋ" where sender.backgroundColor == K.Colors.seaBlue:
            Utilities.shared.playSound("BEAT")
        case "ɪŋ" where sender.backgroundColor == K.Colors.darkGrey:
            Utilities.shared.playSound("NSoft")
        case "h":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("H")
        case "m":
            Utilities.shared.playSound("M")
        case "ð":
            Utilities.shared.playSound("TH")
        case "b":
            Utilities.shared.playSound("B")
        case "dʒ":
            Utilities.shared.playSound("JOKE")
        case "ɡz":
            Utilities.shared.playSound("GZ")
        case "ju":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("YOU")
        case "oʊ":
            Utilities.shared.playSound("BOAT")
        case "tʃ":
            Utilities.shared.playSound("CHOKE")
        case "f":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("F")
        case "l":
            Utilities.shared.playSound("L")
        case "d":
            Utilities.shared.playSound("D")
        case "θ":
            Utilities.shared.playSound("THunvoiced")
        case "ɑr" where sender.backgroundColor == K.Colors.green:
            Utilities.shared.playSound("BOT")
        case "ɑr" where sender.backgroundColor == K.Colors.darkGrey:
            Utilities.shared.playSound("DarkR")
        case "ɛr" where sender.backgroundColor == K.Colors.darkGreen:
            Utilities.shared.playSound("BET")
        case "ɛr" where sender.backgroundColor == K.Colors.darkGrey:
            Utilities.shared.playSound("DarkR")
        case "kw":
            Utilities.shared.playSound("Q")
        case "ɔr" where sender.backgroundColor == K.Colors.purple:
            Utilities.shared.playSound("BOAT")
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
            Utilities.shared.playSound("G")
        case "r":
            Utilities.shared.playSound("R")
        case "z":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("Z")
        case "aʊ":
            Utilities.shared.playSound("BOUT")
        case "ɛŋ" where sender.backgroundColor == K.Colors.pink:
            Utilities.shared.playSound("BAIT")
        case "ɛŋ" where sender.backgroundColor == K.Colors.darkGrey:
            Utilities.shared.playSound("NSoft")
        case "jə":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("YUH")
        case "kʃ":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("KSH")
        case "wə":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("WUH")
        case "wɪ":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("WIH")
        case "k":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("K")
        case "ŋ":
            Utilities.shared.playSound("NSoft")
        case "s":
            Utilities.shared.playSound("S")
        case "ʃ":
            Utilities.shared.playSound("MISSION")
        case "w":
            if sender.backgroundColor == K.Colors.yellow {
                if let range = sender.wildRange,
                    let wildCardNumber = topLabel.attributedText?.attribute(.linkNumber, at: range.location, effectiveRange: nil) as? String
                {
                    showPopTip(range: range, linkString: wildCardNumber)
                }
            }
            Utilities.shared.playSound("W")
        case "ʒ":
            Utilities.shared.playSound("VISION")
        case "æ":
            Utilities.shared.playSound("BAT")
        case "ə":
            Utilities.shared.playSound("BUT")
        case "ɛ":
            Utilities.shared.playSound("BET")
        default:
            break
        }
    }
}

//MARK: - Collection View Data Source Methods
extension TestFlashcard: UICollectionViewDataSource {
    
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
extension TestFlashcard: UICollectionViewDelegateFlowLayout {
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

//MARK:- Utility Functions

extension TestFlashcard {
    
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

