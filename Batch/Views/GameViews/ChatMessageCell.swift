//
//  ChatMessageView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/17/22.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var bubbleConstraints: AnchoredConstraints!
        
    var profileImageConstraints: AnchoredConstraints!
    
    var nameLabelConstraints: AnchoredConstraints!
    
    fileprivate func setupBlueBubbleOnRight() {
        textView.textColor = #colorLiteral(red: 0.1455054283, green: 0.1505178213, blue: 0.1479265988, alpha: 1)
        nameLabel.textColor = UIColor.gray
        bubbleConstraints.leading?.isActive = false
        bubbleConstraints.trailing?.isActive = true
        nameLabelConstraints.trailing?.isActive = true
        nameLabelConstraints.leading?.isActive = false
        profileImageConstraints.trailing?.isActive = true
        profileImageConstraints.leading?.isActive = false
        textView.textAlignment = .right
    }
    
    fileprivate func setupGrayBubbleOnLeft() {
        textView.textColor = #colorLiteral(red: 0.1455054283, green: 0.1505178213, blue: 0.1479265988, alpha: 1)
        nameLabel.textColor = UIColor.gray
        bubbleConstraints.trailing?.isActive = false
        bubbleConstraints.leading?.isActive = true
        profileImageConstraints.trailing?.isActive = false
        profileImageConstraints.leading?.isActive = true
        nameLabelConstraints.trailing?.isActive = false
        nameLabelConstraints.leading?.isActive = true
        textView.textAlignment = .left
    }
    
    var message: Message! {
            didSet {
                textView.text = message.content
                nameLabel.text = "\(self.message.sender.name!), \(self.message.sender.age!)"
                self.setupGrayBubbleOnLeft()
            }
        }
        
    var doesBreakTheSenderChain: Bool! {
        didSet {
            if doesBreakTheSenderChain {
                nameLabel.isHidden = false
                profileImage.isHidden = false
                self.bubbleConstraints.bottom?.constant = 0
            } else {
                nameLabel.isHidden = true
                profileImage.isHidden = true
                self.bubbleConstraints.bottom?.constant = 14
            }
        }
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = false
        tv.font = UIFont(name: "Avenir-Medium", size: 17)
        tv.backgroundColor = .clear
        return tv
    }()
    
    let profileImage: circularImageView = {
        let civ = circularImageView()
        civ.transform = CGAffineTransform(scaleX: 1, y: -1)
        return civ
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.transform = CGAffineTransform(scaleX: 1, y: -1)
        label.font = UIFont(name: "Brown-bold", size: 13)
        return label
    }()
    
    let bubbleContainer: UIView = {
        let bc = UIView()
        bc.transform = CGAffineTransform(scaleX: 1, y: -1)
        bc.layer.cornerRadius = 10
        bc.backgroundColor = .systemGray5
        bc.layer.masksToBounds = true
        return bc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImage()
        setupNameLabel()
        setupBubbleContainer()
    }
    
    override func layoutIfNeeded() {
        bubbleConstraints.leading?.constant = 35
        bubbleConstraints.trailing?.constant = -35
    }
    
    fileprivate func setupProfileImage() {
        addSubview(profileImage)
        profileImageConstraints = profileImage.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 6, right: 10))
        profileImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
    }
    
    fileprivate func setupBubbleContainer() {
        addSubview(bubbleContainer)
        bubbleConstraints = bubbleContainer.anchor(top: topAnchor, bottom: nameLabel.topAnchor, leading: profileImage.trailingAnchor, trailing: trailingAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.70).isActive = true
        bubbleContainer.addSubview(textView)
        bubbleConstraints.leading?.constant = 5
        bubbleConstraints.trailing?.constant = -5
        textView.fillSuperView(padding: UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
    }
    
    fileprivate func setupNameLabel() {
        addSubview(nameLabel)
        nameLabelConstraints = nameLabel.anchor(top: nil, bottom: bottomAnchor, leading: profileImage.trailingAnchor, trailing: trailingAnchor)
        nameLabelConstraints.leading?.constant = 5
        nameLabelConstraints.trailing?.constant = -5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
