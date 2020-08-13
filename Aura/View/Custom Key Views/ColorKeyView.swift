//
//  ColorKeyView.swift
//  Aura
//
//  Created by Max Dolensky on 8/12/20.
//  Copyright © 2020 Max Dolensky. All rights reserved.
//
import UIKit

class ColorKeyView: UIView {
    
    // Data
    var title: String?
    var explanation: String?
    var numRows: Int?
    var numColumns: Int?
    var cornerRadius: CGFloat = 12
    var colors = [UIColor]()
    var doesButtonScrollToView = true
    var myScrollView: UIScrollView?
    
    // Subviews
    var mainStackView: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 10
        return stack

    }()
    
    var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.backgroundColor = .white
        return label
        
    }()
    
    var explanationLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = K.Colors.darkGrey
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    convenience init(frame: CGRect, doesButtonScrollToView: Bool = true, title: String, explanation: String?, numRows: Int, numCol: Int, cornerRadius: CGFloat = 12, colors: [UIColor]) {
        self.init(frame: frame)
        
        self.title = title
        self.explanation = explanation
        self.numRows = numRows
        self.numColumns = numCol
        self.colors = colors
        self.cornerRadius = cornerRadius
        self.doesButtonScrollToView = doesButtonScrollToView
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
        guard let numRows = numRows, let numColumns = numColumns else { return }

        if (numRows*numColumns != colors.count) {

            print("Number of colors must equal #rows * #columns")
            return
        }
        
        self.backgroundColor = .white
        self.roundCorners(cornerRadius: self.cornerRadius)
        
        self.addSubview(mainStackView)
        
        titleLabel.text = title
        mainStackView.addArrangedSubview(titleLabel)
        
        if let explanation = explanation {
            
            explanationLabel.text = explanation
            explanationLabel.isHidden = false
            
        }
        
        else {
            explanationLabel.isHidden = true
        }
        
        mainStackView.addArrangedSubview(explanationLabel)
        
        mainStackView.anchor(top: self.topAnchor,
                             bottom: self.bottomAnchor,
                             leading: self.leadingAnchor,
                             trailing: self.trailingAnchor,
                             height: nil,
                             width: nil,
                             padding: UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20))
        
        var count = 0
        for i in 0..<numRows {
            
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            stackView.spacing = 10
            
            self.mainStackView.addArrangedSubview(stackView)
            
            for j in 0..<numColumns {
                
                
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthAnchor.constraint(equalToConstant: 34).isActive = true
                button.heightAnchor.constraint(equalToConstant: 34).isActive = true
                button.backgroundColor = colors[ (numColumns * i) + j ]
                button.roundCorners(cornerRadius: 17)
                
                // These will be used in the Key VC to scroll to the right key card
                if doesButtonScrollToView &&
                   colors[ (numColumns * i) + j ] != .white &&
                   colors[ (numColumns * i) + j ] != .black &&
                   colors[ (numColumns * i) + j ] != K.Colors.darkGrey &&
                   colors[ (numColumns * i) + j ] != K.Colors.yellow{
                    
                    button.addTarget(self, action: #selector(scrollButtonPressed(_:)), for: .touchUpInside)
                    button.tag = count
                    count += 1
                    
                }
                
                // These will be used in the Full Key View for whatever use we want. Right now does nothing
                else {
                    button.isUserInteractionEnabled = false
                }
                
                stackView.addArrangedSubview(button)

            }
            
        }
        
    }
    
    @objc func scrollButtonPressed(_ sender: UIButton) {
        print(sender.tag)
        if let myScrollView = myScrollView {
            myScrollView.setContentOffset( CGPoint(x: myScrollView.frame.size.width * CGFloat(sender.tag), y: 0.0), animated: true)
        }
        
    }
    
}


