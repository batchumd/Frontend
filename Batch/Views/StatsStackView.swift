//
//  StatsStackView.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/17/22.
//

import Foundation
import UIKit

class StatsStackView: UIStackView {
    
    let gamesPlayedStatBox = statBox(name: "Played")
    
    let wonStatBox = statBox(name: "Matches")
    
    let pointsStatBox = statBox(name: "Score", highlight: true)
    
    init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(gamesPlayedStatBox)
        self.addArrangedSubview(wonStatBox)
        self.addArrangedSubview(pointsStatBox)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
