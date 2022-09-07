//
//  GameStatusBoxView.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/7/22.
//

import UIKit

class GameStatusBoxView: UIStackView {
    
    //MARK: UI Components
    
    let statusTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Gilroy-Extrabold", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 8)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "mainColor")
        self.layer.cornerRadius = 15
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.addSubview(statusTitle)
        statusTitle.fillSuperView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
