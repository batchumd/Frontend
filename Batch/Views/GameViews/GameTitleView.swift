//
//  GameTitleView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation
import UIKit

class GameTitleView: UIView {
    
    var players: ([User], User)! {
        didSet {
            membersCollection.players = players.0
            membersCollection.host = players.1
        }
    }
    
    let membersCollection = PlayersCollectionView()
    
    let statusBox: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor(named: "mainColor")
        stackView.layer.cornerRadius = 15
        stackView.axis = .horizontal
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Gilroy-Extrabold", size: 18)
        label.text = "Round 1: ♋️ Astrology"
        stackView.addArrangedSubview(label)
        let countdownView = UIView()
        countdownView.backgroundColor = .white
        countdownView.layer.cornerRadius = 10
        let countdownLabel = UILabel()
        countdownLabel.text = "17s"
        countdownLabel.textColor = UIColor(named: "mainColor")
        countdownLabel.font = UIFont(name: "Gilroy-Extrabold", size: 18)
        countdownView.addSubview(countdownLabel)
        countdownLabel.fillSuperView(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        stackView.addArrangedSubview(countdownView)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        self.layer.cornerRadius = 25
        addShadow(radius: 8, offset: CGSize(width: 0, height: 20), opacity: 0.08)
        
        addSubview(membersCollection)
        membersCollection.translatesAutoresizingMaskIntoConstraints = false
        membersCollection.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        membersCollection.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        membersCollection.heightAnchor.constraint(equalToConstant: 88).isActive = true
        membersCollection.widthAnchor.constraint(equalToConstant: 284).isActive = true
        
        addSubview(statusBox)
        statusBox.translatesAutoresizingMaskIntoConstraints = false
        statusBox.anchor(top: membersCollection.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
