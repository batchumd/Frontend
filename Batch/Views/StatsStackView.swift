//
//  StatsStackView.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/17/22.
//

import Foundation
import UIKit

class StatsStackView: UIStackView {
    
    let roundsStatBox = statBox(name: "Rounds")
    
    let wonStatBox = statBox(name: "Won")
    
    let pointsStatBox = statBox(name: "Points", highlight: true)
    
    init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(roundsStatBox)
        self.addArrangedSubview(wonStatBox)
        self.addArrangedSubview(pointsStatBox)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
