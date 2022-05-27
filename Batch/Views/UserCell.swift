//
//  ProfileCard.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class UserCell: UICollectionViewCell {

    var user: User! {
        didSet {
            profileImageView.image = user.image
            nameAgeLabel.text = user.name + ", " + String(user.age)
            pointsLabel.text = String(user.points)
        }
    }
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 22)
        label.textColor = UIColor(named: "mainColor")
        return label
    }()
    
    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate let nameAgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "customGray")
        label.textAlignment = .center
        label.font = UIFont(name: "Brown-bold", size: 19)
        return label
    }()
    
    fileprivate let pointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 25)
        label.textColor = UIColor(named: "mainColor")
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [rankLabel, profileImageView, nameAgeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 23
        stackView.setCustomSpacing(15, after: profileImageView)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        
        //Setup stackview
        self.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //Setup points label
        self.addSubview(pointsLabel)
        pointsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        pointsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        //Setup profile image
        profileImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
