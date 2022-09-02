//
//  GameTitleView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation
import UIKit

class GameHeaderView: UIView {
    
    var game: Game? {
        didSet {
            guard let game = game else { return }
            if let players = game.players {
                membersCollection.players = Array(players.values)
            }
            if let question = game.question {
                self.gameStatusBoxView.statusTitle.text = question
            }
            membersCollection.host = game.host

        }
    }
    
    let membersCollection = PlayersCollectionView()
    
    let gameStatusBoxView = GameStatusBoxView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        // Set properties on self
        self.backgroundColor = .white
        self.layer.cornerRadius = 25
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        addShadow(radius: 8, offset: CGSize(width: 0, height: 20), opacity: 0.08)
        
        // Call UI methods
        setupMembersCollection()
        setupGameStatusBoxView()
    }
    
    //MARK: UI Methods
    
    fileprivate func setupMembersCollection() {
        addSubview(membersCollection)
        membersCollection.translatesAutoresizingMaskIntoConstraints = false
        membersCollection.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        membersCollection.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        membersCollection.heightAnchor.constraint(equalToConstant: 88).isActive = true
        membersCollection.widthAnchor.constraint(equalToConstant: 284).isActive = true
    }
    
    fileprivate func setupGameStatusBoxView() {
        addSubview(gameStatusBoxView)
        gameStatusBoxView.anchor(top: membersCollection.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
