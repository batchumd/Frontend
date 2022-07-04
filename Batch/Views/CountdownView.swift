//
//  CountdownView.swift
//  Batch
//
//  Created by Kevin Shiflett on 4/18/22.
//

import Foundation
import UIKit

class CountdownView: UIView {
    
    var fullscreen: Bool = false
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.text = "WE'RE LIVE IN"
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 24)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 0
        return label
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Games start at 9pm est"
        label.font = UIFont(name: "Brown-bold", size: 18)
        return label
    }()
    
    let counter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 45)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if fullscreen != true {
            gradientLayer.frame = bounds
        }
    }
    
    init(fullscreen: Bool = false) {
        self.fullscreen = fullscreen
        
        if fullscreen {
            self.title.font = UIFont(name: "Gilroy-ExtraBold", size: 35)
            self.counter.font = UIFont(name: "GorgaGrotesque-Bold", size: 55)
            self.subtitle.font = UIFont(name: "Brown-bold", size: 22)
            self.subtitle.text = "Come back at 9pm to play!"
        }
        
        super.init(frame: .zero)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 25
        let stackView = UIStackView(arrangedSubviews: [title, counter, subtitle])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor(red: 204/255, green: 93/255, blue: 237/255, alpha: 1.0).cgColor, UIColor(red: 151/255, green: 59/255, blue: 246/255, alpha: 1.0).cgColor]
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
