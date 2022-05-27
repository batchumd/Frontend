//
//  inviteFriendView.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/22/22.
//

import Foundation
import UIKit

class InviteFriendView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "customGray")
        label.textAlignment = .left
        label.text = "Invite your friends!"
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 19)
        return label
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "customGray")
        label.textAlignment = .left
        label.text = "Earn powerup for each who joins."
        label.font = UIFont(name: "Brown-bold", size: 13)
        return label
    }()
    
    let button: UILabel = {
        let button = UILabel()
        button.text = "Invite"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font = UIFont(name: "Gilroy-ExtraBold", size: 17)
        button.textColor = UIColor(named: "mainColor")
        return button
    }()
    
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitle])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStackView, button])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 25
        self.addShadow()
        self.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
