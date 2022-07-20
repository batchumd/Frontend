//
//  MainCountdownView.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/17/22.
//

import UIKit

class CountdownMainView: CountdownView {
    
    let patternLayer = CALayer()
    
    var countdownDelegate: CountdownDelegate?
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.text = "WE'RE LIVE IN"
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 34)
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
        label.text = "Come back at 9pm to play"
        label.font = UIFont(name: "Brown-bold", size: 20)
        return label
    }()
    
    let counter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "- h - m - s"
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 55)
        return label
    }()
    
    override func layoutSubviews() {
        self.patternLayer.frame = self.bounds
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [title, counter, subtitle])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.fillSuperView()
        patternLayer.isHidden = true
        patternLayer.contents = UIImage(named: "celebration")?.cgImage
        patternLayer.contentsGravity = .resizeAspect
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
        title.isHidden = true
        let firstLineAttribute = [NSAttributedString.Key.font : UIFont(name: self.counter.font.fontName, size: 56)!]
        let attributedString = NSMutableAttributedString(string:"We Are \n", attributes: firstLineAttribute)
        let secondLine = "Live!"
        let secondLineAttribute = [NSAttributedString.Key.font : UIFont(name: self.counter.font.fontName, size: 80)!]
        let newAttributedSecondLine: NSAttributedString = NSAttributedString(string: secondLine, attributes: secondLineAttribute)
        attributedString.append(newAttributedSecondLine)
        patternLayer.isHidden = false
        self.counter.attributedText = attributedString
        subtitle.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateTime(_ elapsed: TimeInterval) {
        countdown.currentDate = countdown.currentDate.addingTimeInterval(elapsed)
        self.counter.text = countdown.timeRemaining
        
        if countdown.timeRemaining.contains(where: {$0 == "h"}) {
            self.counter.font = self.counter.font.withSize(50)
        } else if countdown.timeRemaining.contains(where: {$0 == "m"}) {
            self.counter.font = self.counter.font.withSize(70)
        } else {
            self.counter.font = self.counter.font.withSize(100)
        }
        if countdown.isFinished {
            self.setupLobbyReady()
            self.countdownDelegate?.statusChanged(isFinished: true)
        }
    }
}
