//
//  ViewControllerWithGradient.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/01/22.
//

import UIKit

class NavControllerWithGradient: UINavigationController, CAAnimationDelegate {
    
    let gradient: CAGradientLayer = CAGradientLayer()
    var gradientColorSet: [[CGColor]] = []
    var colorIndex: Int = 0
    
    let lightPurple: CGColor = UIColor(red: 222/255, green: 110/255, blue: 255/255, alpha: 1).cgColor
    let mediumPurple: CGColor = UIColor(red: 151/255, green: 59/255, blue: 246/255, alpha: 1).cgColor
    let darkPurple: CGColor = UIColor(red: 106/255, green: 0/255, blue: 216/255, alpha: 1).cgColor
    
    func setupGradient() {
        
        self.gradientColorSet = [
            [lightPurple, mediumPurple],
            [mediumPurple, darkPurple],
            [darkPurple, lightPurple]
        ]
        
        self.gradient.colors = gradientColorSet[colorIndex]
        self.gradient.frame = self.view.bounds
        self.gradient.startPoint = CGPoint(x: 0, y: 0)
        self.gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func animateGradient() {
        gradient.colors = gradientColorSet[colorIndex]
            
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        
            gradientAnimation.duration = 2.0
            
            gradientAnimation.delegate = self
            
            updateColorIndex()
            
            gradientAnimation.toValue = gradientColorSet[colorIndex]
            
            gradientAnimation.fillMode = .forwards
            
            gradientAnimation.isRemovedOnCompletion = false
            
            gradient.add(gradientAnimation, forKey: "colors")
    }
        
    func updateColorIndex() {
        if colorIndex < gradientColorSet.count - 1 {
            colorIndex += 1
        } else {
            colorIndex = 0
        }
    }
    
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animateGradient()
    }
}

