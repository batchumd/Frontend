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
        label.textColor = UIColor(named: "customGray")
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let content: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 17
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.18
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 75).isActive = true
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Brown-Bold", size: 14)
        label.textColor = UIColor(named: "customGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    init(value: Int = 0, name: String = "") {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(valueLabel)
        valueLabel.text = String(value)
        valueLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
        valueLabel.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        self.addSubview(content)
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.addSubview(nameLabel)
        nameLabel.text = name
        nameLabel.topAnchor.constraint(equalTo: content.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
