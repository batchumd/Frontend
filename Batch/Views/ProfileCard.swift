//
//  ProfileCard.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class ProfileCard: UICollectionViewCell {
    
    var user: User! {
        didSet {
//            profileImage.image = user.image
            infoLabel.text = user.name! + ", " + String(user.age!)
        }
    }
    
    let bottomGradient = CAGradientLayer()
    let topGradient = CAGradientLayer()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let playerCountLabel: UILabel = {
        let label = UILabel()
        let imageAttachment = NSTextAttachment(image: UIImage(systemName: "person.2.fill")!)
        let imageOffsetY: CGFloat = -2.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: "1/5")
        completeText.append(textAfterIcon)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Brown-Bold", size: 17)
        label.textColor = .white
        label.attributedText = completeText
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Brown-Bold", size: 16)
        label.textColor = .white
        return label
    }()
    
    func setupBottomGradintLayer() {
        bottomGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        bottomGradient.locations = [0.01,0.25]
        bottomGradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        bottomGradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.layer.insertSublayer(bottomGradient, at: 1)
    }
    
    func setupTopGradientLayer() {
        topGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        topGradient.locations = [0.01,0.25]
        topGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        topGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        topGradient.opacity = 0.8
        layer.insertSublayer(topGradient, at: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        profileImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.addSubview(infoLabel)
        infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.addSubview(playerCountLabel)
        playerCountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        playerCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        setupBottomGradintLayer()
        setupTopGradientLayer()
    }
    
    override func layoutSubviews() {
        bottomGradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        topGradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
