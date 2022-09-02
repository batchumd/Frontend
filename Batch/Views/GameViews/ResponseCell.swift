//
//  ResponseCell.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/7/22.
//

import Foundation
import UIKit

class ResponseCell: UICollectionViewCell {
    
    var message: Message! {
        didSet {
            guard let sender = message.sender else { return }
            textView.text = message.content
            nameLabel.text = "\(sender.name), \(sender.age)"
            profileImage.setCachedImage(urlstring: sender.profileImages[0], size: CGSize(width: 30, height: 30)) {}
        }
    }
    
    lazy var userDetailsView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileImage, nameLabel])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .center
        sv.distribution = .fillProportionally
        return sv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = false
        tv.font = UIFont(name: "Brown-bold", size: 17)
        tv.backgroundColor = .clear
        return tv
    }()
    
    let profileImage: circularImageView = {
        let civ = circularImageView()
        civ.contentMode = .scaleAspectFill
        return civ
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Brown-bold", size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addShadow()
        self.backgroundColor = .white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
                layer.backgroundColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 15
        self.addShadow()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.profileImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.profileImage.widthAnchor.constraint(equalTo: self.profileImage.heightAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [userDetailsView, textView])
        stackView.axis = .vertical
        self.contentView.addSubview(stackView)
        stackView.fillSuperView(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
