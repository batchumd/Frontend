//
//  CountdownView.swift
//  Batch
//
//  Created by Kevin Shiflett on 4/18/22.
//

import Foundation
import UIKit

class CountdownView: UIView {
    
    var timeRemaining: String? {
        didSet {
            if let timeRemaining = timeRemaining {
                self.acitivityIndicator.removeFromSuperview()
                self.counter.text = timeRemaining
            } else {
                self.setupActivityIndicator()
            }
        }
    }
    
    var isFullscreen: Bool
    
    let patternLayer = CALayer()
        
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 22)
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
        label.font = UIFont(name: "Brown-bold", size: 18)
        return label
    }()
    
    let counter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 54)
        return label
    }()
    
    let actionView = CountdownActionLabel()
    
    lazy var stackView = UIStackView(arrangedSubviews: [title, counter, subtitle])

    let acitivityIndicator = ProgressView(lineWidth: 5, dark: false)
    
    override func layoutSubviews() {
        if !isFullscreen {
            self.gradientLayer.frame = bounds
        }
        self.patternLayer.frame = self.bounds
    }
    
    init(isFullscreen: Bool) {
        self.isFullscreen = isFullscreen
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        if isFullscreen { changeViewForFullscreen() }
        stackView.setCustomSpacing(9, after: title)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.fillSuperView(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        patternLayer.isHidden = true
        patternLayer.contents = UIImage(named: "smaller_celebration")?.cgImage
        patternLayer.contentsGravity = .resizeAspectFill
        layer.insertSublayer(patternLayer, at: 0)
        setViewForLobbyClosed()
        self.addSubview(actionView)
        actionView.anchor(top: nil, bottom: self.bottomAnchor, leading: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: -12, right: 0))
        actionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func setupActivityIndicator() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(acitivityIndicator)
        acitivityIndicator.fillSuperView()
        self.addSubview(view)
        view.centerInsideSuperView()
        acitivityIndicator.animateStroke()
        acitivityIndicator.animateRotation()
    }
    
    fileprivate func changeViewForFullscreen() {
        title.font = title.font.withSize(30)
        subtitle.font = subtitle.font.withSize(20)
        counter.font = counter.font.withSize(80)
    }
    
    fileprivate func setViewForLobbyClosed() {
        patternLayer.isHidden = true
        title.text = "Games Go Live In"
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor(red: 204/255, green: 93/255, blue: 237/255, alpha: 1.0).cgColor, UIColor(red: 151/255, green: 59/255, blue: 246/255, alpha: 1.0).cgColor]
        gradient.cornerRadius = 20
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

