//
//  Extensions.swift
//  Aura
//
//  Created by Max Dolensky on 7/7/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//

import UIKit

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
}

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
}

extension NSMutableAttributedString {
    
    func configureBasedOnInput() -> Int {
        
        let text = self.string
        
        if ( text.split(separator: " ").count == 1 ) || ( text.count <= 20 ) {
            self.addAttribute(.font, value: UIFont.systemFont(ofSize: 60, weight: .bold), range: NSRange(location: 0, length: self.length))
            return 1
        }
        
        else {
            self.addAttribute(.font, value: UIFont.systemFont(ofSize: 40, weight: .bold), range: NSRange(location: 0, length: self.length))
            return 0
        }
    }
}
