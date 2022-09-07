//
//  SchoolBarView.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/3/22.
//

import Foundation
import UIKit

class SchoolBarView: UIView {
    
    let valueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 32))
        label.text = "UMD"
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-Extrabold", size: 16)
        return label
    }()
    
    let alert: UIAlertController = {
        let alert = UIAlertController(title: "You're on Batch@UMD", message: "You're a player at University of Maryland (Go Terps!). Batch servers are segmented by school. More schools coming soon!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        return alert
    }()
    
    init(darkMode: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 75, height: 32))
        self.layer.cornerRadius = 10
        self.backgroundColor = darkMode ? .white : UIColor(red: 209/255, green: 57/255, blue: 62/255, alpha: 1.0)
        self.valueLabel.textColor = darkMode ? UIColor(named: "mainColor") : .white
        
        self.addSubview(valueLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
