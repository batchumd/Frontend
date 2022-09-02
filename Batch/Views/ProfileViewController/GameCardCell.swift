//
//  ProfileCard.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class GameCardCell: UICollectionViewCell {
    
    var game: Game! {
        didSet {
            guard let host = game.host else { return }
            profileCardView.profileImage.setCachedImage(urlstring: host.profileImages[0], size: self.bounds.size) {}
            profileCardView.nameLabel.text = host.name + ", " + String(host.age)
            
            let imageAttachment = NSTextAttachment(image: UIImage(systemName: "person.2.fill")!)
            let imageOffsetY: CGFloat = -2.0
            imageAttachment.bounds = CGRect(x: -1.0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            let completeText = NSMutableAttributedString(string: "")
            completeText.append(attachmentString)
            let textAfterIcon = NSAttributedString(string: "\(game.playerIDs.count)/6")
            completeText.append(textAfterIcon)
            
            self.playerCountLabel.attributedText = completeText
            
            if self.game.playerIDs.count >= 6 || game.status != .waiting {
                self.contentView.alpha = 0.5
                self.isUserInteractionEnabled = false
            }
        }
    }
    
    let profileCardView = ProfileCardView(withContent: true)
    
    let playerCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Brown-Bold", size: 17)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        clipsToBounds = true
        backgroundColor = .clear
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.contentView.addSubview(profileCardView)
        self.profileCardView.fillSuperView()
        self.contentView.addSubview(playerCountLabel)
        playerCountLabel.anchor(top: self.contentView.topAnchor, bottom: nil, leading: nil, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
