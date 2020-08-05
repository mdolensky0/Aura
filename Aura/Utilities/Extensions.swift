//
//  Extensions.swift
//  Aura
//
//  Created by Max Dolensky on 7/7/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit
import AVFoundation

//MARK:- UIView Extensions
extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, height: CGFloat?, width: CGFloat?, padding: UIEdgeInsets = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func anchorXCenter(top: NSLayoutYAxisAnchor, bottom: NSLayoutYAxisAnchor?, centerAnchor: NSLayoutXAxisAnchor, width: NSLayoutDimension, height: CGFloat?, padding: UIEdgeInsets = .zero, widthMultiplier: CGFloat = 1, widthOffset: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        centerXAnchor.constraint(equalTo: centerAnchor).isActive = true
        
        widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier, constant: widthOffset).isActive = true
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    func setUnderlineStyle(color: UIColor) {
        
        let border = UIView()
        border.backgroundColor = color
        self.addSubview(border)
        border.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, height: 1.0, width: nil)
        
    }
    
    func setShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat, cornerRadius: CGFloat = 0) {

        self.layer.masksToBounds = false
        self.clipsToBounds = false

        self.backgroundColor = .clear
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
// THIS DOESNT ALLOW SHADOW TO RESIZE IF VIEW CHANGE. WORKS WITHOUT. IF WANT THIS, MUST REDRAW WHEN SUBVIEWS ARE RE-LAYED OUT
        
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
        func setShadowWithBZPath(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat, cornerRadius: CGFloat = 0) {

            self.layer.masksToBounds = false
            self.clipsToBounds = false

            self.backgroundColor = .clear
            
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = offset
            self.layer.shadowRadius = radius

            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    
    func roundCorners(cornerRadius: CGFloat) {
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
    }

}

//MARK:- UIViewController Extensions
extension UIViewController {
    
    func setupToHideKeyboardOnTapOnView() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createButtons(_ attributedString: NSMutableAttributedString) -> [(color: UIColor, ID: String, range: NSRange)] {
 
        // Otherwise Return an array of SoundButtons
        var colors: [(color: UIColor, ID: String, range: NSRange)] = []
        
        attributedString.enumerateAttribute(.foregroundColor, in: NSRange(0..<attributedString.length)) { (color, range, stop) in
            
            if let color = color as? UIColor {
                
                attributedString.enumerateAttribute(.id, in: range) { (id, range, stop) in
                    
                    if let id = id as? String {
                        if color != K.Colors.lightGrey {
                            colors.append((color: color, ID: id, range: range))
                        }
                    }
                }
            }
        }
        return colors
    }
    
    func getDeviceLanguageCode() -> String {
        
        guard let code = Locale.preferredLanguages.first else { return "en" }
        
        let codeAndRegion = code.split(separator: "-").map { String($0) }
        
        if codeAndRegion.count >= 3 {
            
            return "\(codeAndRegion[0])-\(codeAndRegion[1])"
            
        } else { return codeAndRegion[0] }
    }
    
    func startLoadingScreen() {
        loadingView = UIView(frame: self.view.bounds)
        loadingView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView!.center
        activityIndicator.startAnimating()
        loadingView?.addSubview(activityIndicator)
        self.view.addSubview(loadingView!)
        
        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { (t) in
            self.endLoadingScreen()
        }
    }
    
    func endLoadingScreen() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}

fileprivate var loadingView: UIView?

//MARK:- UILabel Extensions
extension UILabel {
    
    func configureBasedOnInput() {
        
        // Set Atrributed String Font Size
        guard let attributedString = self.attributedText else { return }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        let numberOfLines = mutableAttributedString.configureBasedOnInput()
        
        // Configure Label
        self.attributedText = mutableAttributedString
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = numberOfLines == 1 ? true : false
        self.textAlignment = numberOfLines == 1 ? .center : .left

    }
    
    func configureBottomLabel() {
        
        guard let attributedString = self.attributedText else { return }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40, weight: .regular), range: NSRange(location: 0, length: mutableAttributedString.length))
        
        self.attributedText = mutableAttributedString
        self.numberOfLines = 0
    }
    
    func boundingRect(forCharacterRange range: NSRange) -> CGRect? {

        guard let attributedText = attributedText else { return nil }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()

        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0

        layoutManager.addTextContainer(textContainer)

        var glyphRange = NSRange()

        // Convert the range for glyphs.
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)

        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
    
}

//MARK:- NSMutableAttributedString Extensions
extension NSMutableAttributedString {
    
    func configureBasedOnInput() -> Int {
        
        let text = self.string
        
        if ( text.split(separator: " ").count == 1 ) || ( text.count <= 16 ) {
            self.addAttribute(.font, value: UIFont.systemFont(ofSize: 60, weight: .bold), range: NSRange(location: 0, length: self.length))
            return 1
        }
        
        else {
            self.addAttribute(.font, value: UIFont.systemFont(ofSize: 50, weight: .bold), range: NSRange(location: 0, length: self.length))
            return 0
        }
    }
    
    func capitalize(location: Int, length: Int) -> NSMutableAttributedString {

        let result = NSMutableAttributedString(attributedString: self)

        result.enumerateAttributes(in: NSRange(location: location, length: length), options: []) {_, range, _ in
            result.replaceCharacters(in: range, with: (string as NSString).substring(with: range).uppercased())
        }

        return result
    }
    
    func setCapitalLetters(from word: String) -> NSMutableAttributedString {
        
        var indices = [Int]()
        var result = self
        
        for i in 0..<word.count {
            if word[i].isUppercase {
                indices.append(i)
            }
        }
        
        for indice in indices {
            result = result.capitalize(location: indice, length: 1)
        }
        
        return result
    }
    
    func removeSymbols() -> NSMutableAttributedString {

        var indices = [Int]()
        let stringText = self.string
        
        for i in 0..<stringText.count {
            
            if !stringText[i].isLetter && stringText[i] != "'" {
                
                indices.append(i)
                
            }
            
        }
        
        if indices.count == self.length {
            return self
        }
        
        for index in indices.reversed() {
            self.deleteCharacters(in: NSRange(location: index, length: 1))
        }
        
        return self
    }
    
    func replaceSpecialCharacters(from word: String) -> NSMutableAttributedString {

        var indices = [Int]()
        var symbols = [NSMutableAttributedString]()
        
        for i in 0..<word.count {
            
            if !word[i].isLetter && word[i] != "'" {
                
                indices.append(i)
                symbols.append(NSMutableAttributedString(string: String(word[i]) ) )
                
            }
        }
        
        // If the word is all Symbols, nothing would have been deleted and thus no need for replacement
        if indices.count == word.count {
            return self
        }
        
        for (index, symbol) in zip(indices, symbols) {
            
            self.insert(symbol, at: index)
            
        }
        
      return self
    }
}

//MARK:- NSAttributedString.Key Extensions
extension NSAttributedString.Key {
    static let id = NSAttributedString.Key("id")
    static let linkNumber = NSAttributedString.Key("linkNumber")
}

//MARK:- String Extensions

// ==========================================================================================
// This is an extension to the String class which takes as input a substring we are searching
// for, and returns a list of all starting indices for the matches within the string
// Use like this:
//      let keyword = "a"
//      let html = "aaaa"
//      let indicies = html.indicesOf(string: keyword)
//      print(indicies) // result --> [0, 1, 2, 3]
// ===========================================================================================

extension String {
    
    func removeSymbols() -> String {
        
        let newString = self.filter { $0.isLetter || $0 == "'" }
        return newString != "" ? newString : self
        
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex

        while searchStartIndex < self.endIndex,
            // Finds and returns the range of the first occurrence of a given string within a
            // given range of the String, subject to given options, using the specified locale, if any.
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            // Runs this block of code only if searchStartIndex < last index of the word, and if range finds a match
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        return indices
    }
}

public extension String {
  subscript(value: Int) -> Character {
    self[index(at: value)]
  }
}

public extension String {
  subscript(value: NSRange) -> Substring {
    self[value.lowerBound..<value.upperBound]
  }
}

// =========================================================================
// All of this allows me to access substrings in a cleaner way
// Examples:
//          let text = "Hello world"
//          text[0] // H
//          text[...3] // "Hell"
//          text[6..<text.count] // world
//          text[NSRange(location: 6, length: 3)] // wor
// =========================================================================
public extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(at: value.lowerBound)...index(at: value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(at: value.lowerBound)..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(at: value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(at: value.lowerBound)...]
  }
}

private extension String {
  func index(at offset: Int) -> String.Index {
    index(startIndex, offsetBy: offset)
  }
}

//MARK:- UIColor Extensions
extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}

//MARK:- UIGestureRecognizer Extensions

extension UITapGestureRecognizer {

    func indexForTapAttributedTextInLabel(label: UILabel) -> Int? {
        
        // Configure NSTextContainer
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        // Configure NSLayoutManager and add the text container
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        guard let attributedText = label.attributedText else {return nil}
        
        // Configure NSTextStorage and apply the layout manager
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addAttribute(NSAttributedString.Key.font, value: label.font!, range: NSMakeRange(0, attributedText.length))
        textStorage.addLayoutManager(layoutManager)

        // get the tapped character location
        let locationOfTouchInLabel = self.location(in: label)
        
        // account for text alignment and insets
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        var alignmentOffset: CGFloat!
        switch label.textAlignment {
        case .left, .natural, .justified:
            alignmentOffset = 0.0
        case .center:
            alignmentOffset = 0.5
        case .right:
            alignmentOffset = 1.0
        @unknown default:
            fatalError()
        }
        
        let xOffset = ((label.bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((label.bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)
        
        // work out which character was tapped
        let characterIndex = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return characterIndex
    }
}

//MARK:- Stack View Extensions

extension UIStackView {

    func addArrangedSubview(_ v:UIView, withMargin m:UIEdgeInsets ) {
        let containerForMargin = UIView()
        containerForMargin.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: containerForMargin.topAnchor, constant:m.top ),
            v.bottomAnchor.constraint(equalTo: containerForMargin.bottomAnchor, constant: m.bottom ),
            v.leftAnchor.constraint(equalTo: containerForMargin.leftAnchor, constant: m.left),
            v.rightAnchor.constraint(equalTo: containerForMargin.rightAnchor, constant: m.right)
        ])

        addArrangedSubview(containerForMargin)
    }
    
    func addCenteredSubview(_ v: UIView, stackViewParent: UIView) {
        
        let containerView = UIView()
        containerView.addSubview(v)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // center the view inside its container
        v.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        v.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        // set a height constraint so the stackView can adjust its size
        containerView.heightAnchor.constraint(greaterThanOrEqualTo: v.heightAnchor).isActive = true

        self.addArrangedSubview(containerView)
        
        // set the width of the container to be the same width as the scroll view so that paging works
        containerView.widthAnchor.constraint(equalTo: stackViewParent.widthAnchor).isActive = true
    }
    
}

//MARK: - UIButton Extensions

extension UIButton {
    
    func styleFilledButton(fillColor color: UIColor) {
        
        self.backgroundColor = color
        self.layer.cornerRadius = 24
        self.tintColor = .white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)

    }
    
    func styleHollowbutton(outlineColor color: UIColor) {
        
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 24
        self.tintColor = color
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
 
    }
    
}

//MARK: - Text Field Extensions

extension UITextField {
    
    func styleTextFieldWithUnderline(ofColor bottomLineColor: UIColor) {
        
        self.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = bottomLineColor.cgColor
        self.layer.addSublayer(bottomLine)
        
    }
    
}
