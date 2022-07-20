//
//  StatsProfileCell.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/19/22.
//

import UIKit

class StatsProfileCell: UICollectionViewCell {
    
    let statsStackView = StatsStackView()
    
    var stats: [String: Int]? {
        didSet {
            guard let stats = stats else {return}
            self.statsStackView.wonStatBox.statValue = stats["won"]
            self.statsStackView.pointsStatBox.statValue = stats["points"]
            self.statsStackView.roundsStatBox.statValue = stats["rounds"]
        }
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(statsStackView)
        statsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        statsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        statsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        statsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
