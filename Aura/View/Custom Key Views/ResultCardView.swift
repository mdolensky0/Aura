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

protocol ResultCardDelegate {
    
    func presentDeckSelectionView()
    func goToLogin()
}

class ResultCardView: UIView {
    
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
    var isFlashcard = false
    var delegate: ResultCardDelegate?
    
    // SUBVIEWS
    var topLabel: UILabel = {
        
        let label = UILabel()
        label.clipsToBounds = false
        label.isUserInteractionEnabled = true
        label.lineBreakMode = .byWordWrapping
        label.baselineAdjustment = .none
        return label
        
    }()
    
    var bottomLabel: UILabel = {
        
        let label = UILabel()
        return label
        
    }()
    
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
    
    let addFlashcardBackgroundView = UIView()
    
    var soundItOutCollectionView: UICollectionView = {
       
        let cv = DynamicCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        return cv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(frame: CGRect, results: [ColorResultModel], bottomLabelText: String, soundItOutColors: [(color: UIColor, ID: String, range: NSRange)], delegate: ResultCardDelegate? = nil, isFlashcard: Bool = false) {
        
        self.init(frame: frame)
        
        self.results = results
        self.bottomLabelText = bottomLabelText
        self.soundItOutColors = soundItOutColors
        self.isFlashcard = isFlashcard
        self.delegate = delegate

        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func setupView() {
        
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
        
        // Configure Bottom Label
        
        bottomLabel.attributedText = NSAttributedString(string: bottomLabelText)
        bottomLabel.configureBottomLabel()
        
        // Add Flashcard Button to its Background View
        if !isFlashcard {
            
            addFlashcardBackgroundView.addSubview(addFlashcardButton)
            
            addFlashcardButton.anchor(top: addFlashcardBackgroundView.topAnchor,
                                      bottom: addFlashcardBackgroundView.bottomAnchor,
                                      leading: addFlashcardBackgroundView.leadingAnchor,
                                      trailing: addFlashcardBackgroundView.trailingAnchor,
                                      height: nil,
                                      width: nil)
        }

        
        // Setup Collection View
        setupCollectionView()
        
        // Add subviews to Result Card
        self.addSubview(topLabel)
        self.addSubview(bottomLabel)
        self.addSubview(soundButton)
        self.addSubview(loopButton)
        self.addSubview(lineDividerView)
        self.addSubview(soundItOutCollectionView)
        
        if !isFlashcard {
            self.addSubview(addFlashcardBackgroundView)
        }
        
        // Setup Result Card Layout Constraints for subviews
        setResultViewConstraints()
        
        // Hide Unecessary Views in Result Controller
        updateResultSubviewVisibilities()
        
    }
    
    func setupCollectionView() {
        
        soundItOutCollectionView.delegate = self
        soundItOutCollectionView.dataSource = self
        soundItOutCollectionView.register(SoundItOutCell.self, forCellWithReuseIdentifier: SoundItOutCell.identifier)
        soundItOutCollectionView.isScrollEnabled = false
    }
    
    func setResultViewConstraints() {
        
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lineDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineDividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineDividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        loopButton.anchor(top: self.topAnchor,
                          bottom: nil,
                          leading: nil,
                          trailing: self.trailingAnchor,
                          height: nil,
                          width: nil,
                          padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -10))
        
        soundButton.anchor(top: self.topAnchor,
                           bottom: nil,
                           leading: nil,
                           trailing: loopButton.leadingAnchor,
                           height: nil,
                           width: nil,
                           padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -10))
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.topAnchor.constraint(equalTo: soundButton.bottomAnchor, constant: 27).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        topLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 10).isActive = true
        topLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10).isActive = true
        
        soundItOutCollectionView.anchor(top: topLabel.bottomAnchor,
                                        bottom: lineDividerView.topAnchor,
                                        leading: self.leadingAnchor,
                                        trailing: self.trailingAnchor,
                                        height: nil,
                                        width: nil,
                                        padding: UIEdgeInsets(top: 10, left: 20, bottom: -20, right: -20))
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.topAnchor.constraint(equalTo: lineDividerView.bottomAnchor, constant: 20).isActive = true
        bottomLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        bottomLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 10).isActive = true
        bottomLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10).isActive = true
        
        if !isFlashcard {
            
            addFlashcardBackgroundView.anchor(top: bottomLabel.bottomAnchor,
                                              bottom: self.bottomAnchor,
                                              leading: nil,
                                              trailing: self.trailingAnchor,
                                              height: 30,
                                              width: 30,
                                              padding: UIEdgeInsets(top: 10, left: 0, bottom: -10, right: -10))
            
        }
        
        else {
            bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }

        
    }
    
    func updateResultSubviewVisibilities() {
        
        if results.count == 1 {
            
            if results[0].audioString != nil {
                    soundButton.isHidden = false
                    loopButton.isHidden = false
                }
                
                else {
                    soundButton.isHidden = true
                    loopButton.isHidden = true
                }

                soundItOutCollectionView.isHidden = false
                
            }
            
            else {
                
                soundButton.isHidden = true
                loopButton.isHidden = true
                soundItOutCollectionView.isHidden = true
                
            }
            
        }
    
//MARK: - Selector Functions
    
    @objc func soundButtonPressed(_ sender: UIButton) {
        
        if let soundURL = results[sender.tag].audioString {
            
            Utilities.shared.playAudioFile(urlString: soundURL, loop: 0)
            
        }
        
    }
    
    @objc func loopButtonPressed(_ sender: UIButton) {
        
        if let soundURL = results[sender.tag].audioString {
            
            Utilities.shared.playAudioFile(urlString: soundURL, loop: 5)
            
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
    
    @objc func addFlashcardButtonPressed() {
        
        if Utilities.shared.isUserSignedIn {
            self.delegate?.presentDeckSelectionView()
        }
        
        else {
            self.delegate?.goToLogin()
        }
    }
    
}

//MARK: - Collection View Data Source Methods
extension ResultCardView: UICollectionViewDataSource {
    
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
extension ResultCardView: UICollectionViewDelegateFlowLayout {
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

extension ResultCardView {
        
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
