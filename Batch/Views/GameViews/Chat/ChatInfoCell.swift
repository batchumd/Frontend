//
//  ChatInfoView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/17/22.
//

import UIKit

class ChatInfoCell: UICollectionViewCell {
    
    var message: Message! {
            didSet {
                informationLabel.text = "info"
            }
        }
    
    let informationLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        label.textColor = UIColor.gray
        label.transform = CGAffineTransform(scaleX: 1, y: -1)
        label.font = UIFont(name: "Brown-bold", size: 13)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(informationLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
