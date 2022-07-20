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
        let stackView = UIStackView(arrangedSubviews: [UIView(), profileImageView, nameAgeLabel, statsStackView, UIView()])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let statsStackView = StatsStackView()
    
    override func layoutSubviews() {
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
        statsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 25).isActive = true
        statsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -25).isActive = true
        statsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    func addShadow(radius: CGFloat = 10, offset: CGSize? = nil, opacity: Float = 0.16, color: UIColor = .black) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset ?? .zero
        layer.shadowRadius = radius
        backgroundColor = .white
    }
}
