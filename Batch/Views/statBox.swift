//
//  statBox.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/5/21.
//

import Foundation
import UIKit

class statBox: UIView {
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 37)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Brown-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    init(value: Int = 0, name: String = "", highlight: Bool = false) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if highlight {
            valueLabel.textColor = UIColor(named: "mainColor")
            nameLabel.textColor = UIColor(named: "mainColor")
        } else {
            valueLabel.textColor = UIColor(named: "customGray")
            nameLabel.textColor = UIColor(named: "customGray")
        }
        
        self.addSubview(nameLabel)
        nameLabel.text = name
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.addSubview(valueLabel)
        valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        valueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        valueLabel.text = String(value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
