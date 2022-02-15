//
//  nearbyButton.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit

class nearbyButton: UIButton {
    
    init(numberOnline: Int = 0, distance: Int = 0) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.image = UIImage(systemName: "circle.fill")
            config.cornerStyle = .capsule
            config.background.backgroundColor = UIColor.white
            config.titlePadding = 5
            config.imagePadding = 5
            var text = AttributedString.init("\(numberOnline) online within \(distance)mi")
            text.font = UIFont(name: "Brown-Bold", size: 17)
            text.foregroundColor = UIColor(named: "customGray")
            config.attributedTitle = text
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
            self.configuration = config
        } else {
            backgroundColor = .white
            layer.cornerRadius = frame.height / 2
            self.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            self.backgroundColor = .white
            self.setTitle("\(numberOnline) online within \(distance)mi", for: .normal)
            self.titleLabel?.font = UIFont(name: "Brown-Bold", size: 17)
            self.setTitleColor(UIColor(named: "customGray"), for: .normal)
        }
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        self.tintColor = .systemGreen
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.18
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
