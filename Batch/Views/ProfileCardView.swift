//
//  ProfileCardView.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/17/22.
//

import UIKit

class ProfileCardView: UIView {
    
    let bottomGradient = CAGradientLayer()
    let topGradient = CAGradientLayer()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    init(withContent: Bool) {
        super.init(frame: .zero)
        self.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        profileImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        if withContent {
            setupContent()
        }
    }
    
    func setupContent() {
        self.addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        setupBottomGradintLayer()
        setupTopGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func layoutSubviews() {
        bottomGradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        topGradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        nameLabel.font = UIFont(name: "Gilroy-Extrabold", size: self.frame.width * 0.1)
    }
}
