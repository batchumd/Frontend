//
//  ProfileCard.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class ProfileCardCell: UICollectionViewCell {
    
    var user: User! {
        didSet {
            profileCardView.nameLabel.text = user.name + ", " + String(user.age)
        }
    }
    
    let profileCardView = ProfileCardView()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
