//
//  File.swift
//  Batch
//
//  Created by Kevin Shiflett on 4/18/22.
//

import UIKit

class ProfileBoxView: UIView {
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settings")?.withTintColor(.systemGray2), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameAgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "customGray")
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 25)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), profileImageView, nameAgeLabel, statsView, UIView()])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let roundsStatBox = statBox(name: "Rounds")
    
    let wonStatBox = statBox(name: "Won")
    
    let pointsStatBox = statBox(name: "Points", highlight: true)
    
    lazy var statsView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [roundsStatBox, wonStatBox, pointsStatBox])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        addShadow()
        self.layer.cornerRadius = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        statsView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 40).isActive = true
        statsView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -40).isActive = true
        statsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.addSubview(settingsButton)
        settingsButton.anchor(top: topAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    func addShadow(radius: CGFloat = 10, offset: CGSize? = nil, opacity: Float = 0.16) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset ?? .zero
        layer.shadowRadius = radius
        backgroundColor = .white
    }
}
