//
//  ProgressIndicatorView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/15/22.
//

import UIKit

class ProgressView: UIView {
    
    let lineWidth: CGFloat
    
    let complete: Bool = false
    
    let dark: Bool
    
    private lazy var shapeLayer: ProgressShapeLayer = {
        return ProgressShapeLayer(strokeColor: self.dark ? UIColor(named: "mainColor")! : .white, lineWidth: lineWidth)
    }()
    
    // MARK: - Initialization
    
    init(frame: CGRect, lineWidth: CGFloat, dark: Bool = false) {
        self.lineWidth = lineWidth
        self.dark = dark
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
    }
    
    convenience init(lineWidth: CGFloat, dark: Bool = false) {
        self.init(frame: .zero, lineWidth: lineWidth, dark: dark)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Animations
        func animateStroke() {
            
            let startAnimation = StrokeAnimation(
                type: .start,
                beginTime: 0.25,
                fromValue: 0.0,
                toValue: 1.0,
                duration: 0.75
            )
            // 2
            let endAnimation = StrokeAnimation(
                type: .end,
                fromValue: 0.0,
                toValue: 1.0,
                duration: 0.75
            )
            // 3
            let strokeAnimationGroup = CAAnimationGroup()
            strokeAnimationGroup.duration = 1
            strokeAnimationGroup.repeatDuration = .infinity
            strokeAnimationGroup.animations = [startAnimation, endAnimation]
            // 4
            shapeLayer.add(strokeAnimationGroup, forKey: nil)
            // 5
            self.layer.addSublayer(shapeLayer)
        }
    
    func animateRotation() {
            let rotationAnimation = RotationAnimation(
                direction: .z,
                fromValue: 0,
                toValue: CGFloat.pi * 2,
                duration: 2,
                repeatCount: .greatestFiniteMagnitude
            )
            
            self.layer.add(rotationAnimation, forKey: nil)
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            
        self.layer.cornerRadius = self.frame.width / 2
            
        let path = UIBezierPath(ovalIn:
            CGRect(
                x: 0,
                y: 0,
                width: self.bounds.width,
                height: self.bounds.width
            )
        )

        shapeLayer.path = path.cgPath
    }
}


