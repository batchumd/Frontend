//
//  File.swift
//  Batch
//
//  Created by Kevin Shiflett on 4/18/22.
//

import UIKit

class ProfileBoxView: UIView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nicole")!
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
        label.text = "Nicole, 28"
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 25)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameAgeLabel, statsView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        for object in stackView.arrangedSubviews {
            stackView.setCustomSpacing(18, after: object)
        }
        return stackView
    }()
    
    lazy var statsView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statBox(value: 10, name: "Played"), statBox(value: 2, name: "Won"), statBox(value: 2, name: "Hosted", highlight: true)])
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/3).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        statsView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -80).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    func addShadow() {
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.16
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        backgroundColor = .white
    }
}
