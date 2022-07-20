//
//  CountdownView.swift
//  Batch
//
//  Created by Kevin Shiflett on 4/18/22.
//

import Foundation
import UIKit

protocol CountdownDelegate {
    func statusChanged(isFinished: Bool)
}

class CountdownPreviewView: CountdownView {
    
    let patternLayer = CALayer()
    
    var countdownDelegate: CountdownDelegate?
    
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
        label.text = "- h - m - s"
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 45)
        return label
    }()
    
    override func layoutSubviews() {
        self.gradientLayer.frame = bounds
        self.patternLayer.frame = self.bounds
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [title, counter, subtitle])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        self.clipsToBounds = true
        self.layer.cornerRadius = 25
        stackView.fillSuperView()
        patternLayer.isHidden = true
        patternLayer.contents = UIImage(named: "smaller_celebration")?.cgImage
        patternLayer.contentsGravity = .resizeAspectFill
        layer.insertSublayer(patternLayer, at: 0)
    }
    
    func setupCountDown(_ date: Date?) {
        self.countdown = GameCountdown(currentDate: date ?? Date())
        DispatchQueue.main.async {
            self.updateTime(TimeInterval(0))
            if self.countdownTimer == nil {
                self.countdownTimer = CustomTimer(handler: { elapsed in
                    self.updateTime(elapsed)
                })
            }
        }
    }
    
    func setupLobbyReady() {
        patternLayer.isHidden = false
        title.text = "IT'S TIME"
        counter.text = "We're Live!"
        subtitle.text = "Tap to join"
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
    
    @objc func updateTime(_ elapsed: TimeInterval) {
        countdown.currentDate = countdown.currentDate.addingTimeInterval(elapsed)
        self.counter.text = countdown.timeRemaining
        if countdown.isFinished {
            self.setupLobbyReady()
            self.countdownDelegate?.statusChanged(isFinished: true)
        }
    }
}
