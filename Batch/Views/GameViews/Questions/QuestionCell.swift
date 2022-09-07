//
//  QuestionCell.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/18/22.
//

import Foundation
import UIKit

class QuestionCell: UICollectionViewCell {
    
    var question: String! {
        didSet {
            if question != "Type My Own" {
                label.text = "\"\(question!)\""
            } else {
                label.text = question
            }
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Brown-bold", size: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.isSelected {
            self.backgroundColor = UIColor(named: "mainColor")
            self.label.textColor = .white
        }
        self.addShadow()
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
                layer.backgroundColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 15
        self.addShadow()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        label.fillSuperView(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        self.backgroundColor = .white

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
