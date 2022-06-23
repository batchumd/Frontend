//
//  ContinueButton.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/15/22.
//

import Foundation
import UIKit

class ContinueButton: UIButton {
    
    let loadingIndicator = ProgressView(lineWidth: 5, dark: true)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.buttonSize = .large
            filled.imagePlacement = .all
            filled.imagePadding = 5
            filled.baseBackgroundColor = UIColor.white
            filled.image = UIImage(named: "continue")!.withTintColor(UIColor(named: "mainColor")!)
            self.configuration = filled
        }
    }
    
    func disable() {
        self.isUserInteractionEnabled = false
        if #available(iOS 15.0, *) {
            self.configuration?.image = UIImage()
        }
        self.setupLoadingIndicator()
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
        if #available(iOS 15.0, *) {
            self.configuration?.image = UIImage(named: "continue")!.withTintColor(UIColor(named: "mainColor")!)
        }
        self.loadingIndicator.removeFromSuperview()
    }
    
    fileprivate func setupLoadingIndicator() {
        
        self.addSubview(loadingIndicator)
        
        loadingIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        loadingIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        loadingIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        loadingIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        loadingIndicator.animateStroke()
        loadingIndicator.animateRotation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
