//
//  PointsLabelForNavBar.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/3/22.
//

import Foundation
import UIKit

class PointsLabelBarView: UIView {
    
    var value: Int! {
        didSet {
            self.valueLabel.text = String(value)
        }
    }
        
    let valueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: -10, width: 75, height: 30))
        label.textAlignment = .right
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 25)
        label.textColor = UIColor(named: "mainColor")
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: 75, height: 30))
        label.text = "Score"
        label.textAlignment = .right
        label.font = UIFont(name: "Brown-Bold", size: 15)
        label.textColor = UIColor.systemGray2
        return label
    }()
        
    init(darkMode: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 75, height: 30))
        titleLabel.textColor = darkMode ? UIColor.white : UIColor.systemGray2
        valueLabel.textColor = darkMode ? UIColor.white : UIColor.init(named: "mainColor")
        
        self.addSubview(valueLabel)
        self.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
