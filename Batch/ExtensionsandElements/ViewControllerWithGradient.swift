//
//  ViewControllerWithGradient.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/01/22.
//

import UIKit

class ViewControllerWithGradient: UIViewController, CAAnimationDelegate {
    
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
            /*
             Assign the colors to the gradient layer that you want the animation to begin with.
             These colors are given by the colorIndex:
             */
            gradient.colors = gradientColorSet[colorIndex]
            
            //Initialize a gradient animation object and assign an animation duration.
            let gradientAnimation = CABasicAnimation(keyPath: "colors")
            gradientAnimation.duration = 2.0
            
            // Assign this view controller as the delegate of the gradient animation
            gradientAnimation.delegate = self
            
            // At this point, update the colorIndex by one. Look below to see the implementation.
            updateColorIndex()
            
            /*
             You just updated the color index above so now you can tell the animation that you want
             the animation to go from the previous colors to the new ones given by the updated colorIndex.
             */
            gradientAnimation.toValue = gradientColorSet[colorIndex]
            
            // Preserve the changes introduced by the animation when the animation completes
            gradientAnimation.fillMode = .forwards
            
            // Do not remove the animation when it completes
            gradientAnimation.isRemovedOnCompletion = false
            
            // Add the animation to the gradient layer by a key "colors"
            gradient.add(gradientAnimation, forKey: "colors")
        }
        
        // Cycle through the color sets one by one
    func updateColorIndex() {
        if colorIndex < gradientColorSet.count - 1 {
            colorIndex += 1
        } else {
            colorIndex = 0
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateGradient()
        }
    }
}
