//
//  Page7.swift
//  Aura
//
//  Created by Maxwell Dolensky on 10/23/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

class Page7: UIView {

    var mainHeader: UILabel = {
        let l = UILabel()
        l.text = "Get the pronunciation of any word or sentence"
        l.numberOfLines = 2
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()
    
    var step1Header: UILabel = {
        let l = UILabel()
        l.text = "Step 1:"
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()
    
    var step1Text: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .left
        
        let text1 = NSMutableAttributedString(string: "Set the ")
        let text2 = NSMutableAttributedString(string: "Input ")
        let text3 = NSMutableAttributedString(string: "to ")
        let text4 = NSMutableAttributedString(string: "English ")
        let text5 = NSMutableAttributedString(string: "and leave\nthe ")
        let text6 = NSMutableAttributedString(string: "Output ")
        let text7 = NSMutableAttributedString(string: "as ")
        let text8 = NSMutableAttributedString(string: "Am. English HD.")
        
        
        text1.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text1.length))
        text2.addAttribute(.foregroundColor, value: K.DesignColors.primary, range: .init(location: 0, length: text2.length))
        text3.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text3.length))
        text4.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text4.length))
        text5.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text5.length))
        text6.addAttribute(.foregroundColor, value: K.Colors.pink, range: .init(location: 0, length: text6.length))
        text7.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text7.length))
        text8.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text8.length))
        
        if UIScreen.main.bounds.height > 667 {
            text1.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: .init(location: 0, length: text1.length))
            text2.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: .init(location: 0, length: text2.length))
            text3.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: .init(location: 0, length: text3.length))
            text4.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 15), range: .init(location: 0, length: text4.length))
            text5.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: .init(location: 0, length: text5.length))
            text6.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: .init(location: 0, length: text6.length))
            text7.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: .init(location: 0, length: text7.length))
            text8.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 15), range: .init(location: 0, length: text8.length))
        } else {
            text1.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: .init(location: 0, length: text1.length))
            text2.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: .init(location: 0, length: text2.length))
            text3.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: .init(location: 0, length: text3.length))
            text4.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 13), range: .init(location: 0, length: text4.length))
            text5.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: .init(location: 0, length: text5.length))
            text6.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: .init(location: 0, length: text6.length))
            text7.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: .init(location: 0, length: text7.length))
            text8.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 13), range: .init(location: 0, length: text8.length))
        }

        
        text1.append(text2)
        text1.append(text3)
        text1.append(text4)
        text1.append(text5)
        text1.append(text6)
        text1.append(text7)
        text1.append(text8)
        
        l.attributedText = text1
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()
    
    var step2Header: UILabel = {
        let l = UILabel()
        l.text = "Step 2:"
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()
    
    var step2Text: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .left
        
        let text1 = NSMutableAttributedString(string: "Enter the word into the ")
        let text2 = NSMutableAttributedString(string: "text box ")
        let text3 = NSMutableAttributedString(string: "or tap\nthe ")
        let text4 = NSMutableAttributedString(string: "audio button ")
        let text5 = NSMutableAttributedString(string: "to search with speech.")
        
        text1.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text1.length))
        text2.addAttribute(.foregroundColor, value: K.Colors.orange, range: .init(location: 0, length: text2.length))
        text3.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text3.length))
        text4.addAttribute(.foregroundColor, value: K.Colors.darkGreen, range: .init(location: 0, length: text4.length))
        text5.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text5.length))
        
        text1.append(text2)
        text1.append(text3)
        text1.append(text4)
        text1.append(text5)
        
        if UIScreen.main.bounds.height > 667 {
            text1.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: .init(location: 0, length: text1.length))
        } else {
            text1.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: .init(location: 0, length: text1.length))
        }
        
        
        l.attributedText = text1
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()
    
    var step3Header: UILabel = {
        let l = UILabel()
        l.text = "Step 3:"
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()
    
    var step3Text: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .left
        
        let text1 = NSMutableAttributedString(string: "Click ")
        let text2 = NSMutableAttributedString(string: "Search ")
        let text3 = NSMutableAttributedString(string: "and watch your input\n")
        let text4 = NSMutableAttributedString(string: "transform into English HD ")
        let text5 = NSMutableAttributedString(string: "to search\nwith speech.")
        
        text1.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text1.length))
        text2.addAttribute(.foregroundColor, value: K.Colors.blue, range: .init(location: 0, length: text2.length))
        text3.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text3.length))
        text4.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text4.length))
        text5.addAttribute(.foregroundColor, value: UIColor.gray, range: .init(location: 0, length: text5.length))
        
        text1.append(text2)
        text1.append(text3)
        text1.append(text4)
        text1.append(text5)
        
        if UIScreen.main.bounds.height > 667 {
            text1.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: .init(location: 0, length: text1.length))
        } else {
            text1.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: .init(location: 0, length: text1.length))
        }
        
        l.attributedText = text1
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        return l
    }()
    
    let iv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "searchPronunciation")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
        
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        
        self.addSubview(mainHeader)
        self.addSubview(step1Header)
        self.addSubview(step1Text)
        self.addSubview(step2Header)
        self.addSubview(step2Text)
        self.addSubview(step3Header)
        self.addSubview(step3Text)
        self.addSubview(iv)
        
        if UIScreen.main.bounds.height > 736 {
            setConstraintsForLargerPhone()
        } else if UIScreen.main.bounds.height > 667 {
            setConstraintsForSmallerPhone()
        } else {
            setConstraintsForSmallestPhone()
        }

    }
    
    func setConstraintsForLargerPhone() {
        mainHeader.anchor(top: self.topAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 60, left: 30, bottom: 0, right: -30))
        
        step1Header.anchor(top: mainHeader.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 15, left: 40, bottom: 0, right: -40))
        
        step1Text.anchor(top: step1Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 10, left: 40, bottom: 0, right: -40))
        
        step2Header.anchor(top: step1Text.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 15, left: 40, bottom: 0, right: -40))
        
        step2Text.anchor(top: step2Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 10, left: 40, bottom: 0, right: -40))
        
        step3Header.anchor(top: step2Text.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 15, left: 40, bottom: 0, right: -40))
        
        step3Text.anchor(top: step3Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 10, left: 40, bottom: 0, right: -40))
        
        iv.anchor(top: step3Text.bottomAnchor,
                        bottom: self.bottomAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 0, left: 10, bottom: -70, right: -10))
    }
    
    func setConstraintsForSmallerPhone() {
        mainHeader.anchor(top: self.topAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 40, left: 30, bottom: 0, right: -30))
        
        step1Header.anchor(top: mainHeader.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 12, left: 40, bottom: 0, right: -40))
        
        step1Text.anchor(top: step1Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 8, left: 40, bottom: 0, right: -40))
        
        step2Header.anchor(top: step1Text.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 12, left: 40, bottom: 0, right: -40))
        
        step2Text.anchor(top: step2Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 8, left: 40, bottom: 0, right: -40))
        
        step3Header.anchor(top: step2Text.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 12, left: 40, bottom: 0, right: -40))
        
        step3Text.anchor(top: step3Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 8, left: 40, bottom: 0, right: -40))
        
        iv.anchor(top: step3Text.bottomAnchor,
                        bottom: self.bottomAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 0, left: 10, bottom: -40, right: -10))
    }
    
    func setConstraintsForSmallestPhone() {
        
        mainHeader.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        step1Header.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        step2Header.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        step3Header.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        mainHeader.anchor(top: self.topAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: -20))
        
        step1Header.anchor(top: mainHeader.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 8, left: 30, bottom: 0, right: -30))
        
        step1Text.anchor(top: step1Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 4, left: 30, bottom: 0, right: -30))
        
        step2Header.anchor(top: step1Text.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 8, left: 30, bottom: 0, right: -30))
        
        step2Text.anchor(top: step2Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 4, left: 30, bottom: 0, right: -30))
        
        step3Header.anchor(top: step2Text.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 8, left: 30, bottom: 0, right: -30))
        
        step3Text.anchor(top: step3Header.bottomAnchor,
                         bottom: nil,
                         leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         height: nil,
                         width: nil,
                         padding: UIEdgeInsets(top: 4, left: 30, bottom: 0, right: -30))
        
        iv.anchor(top: step3Text.bottomAnchor,
                        bottom: self.bottomAnchor,
                        leading: self.leadingAnchor,
                        trailing: self.trailingAnchor,
                        height: nil,
                        width: nil,
                        padding: UIEdgeInsets(top: 0, left: 10, bottom: -40, right: -10))
    }

}
