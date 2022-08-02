//
//  CountdownView.swift
//  Batch
//
//  Created by Kevin Shiflett on 4/18/22.
//

import Foundation
import UIKit

class CountdownView: UIView {
    
    var countdown: GameCountdown!
        
    var countdownTimer: CustomTimer?
    
    var isFullscreen: Bool
    
    let patternLayer = CALayer()
        
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
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
        label.font = UIFont(name: "Brown-bold", size: 18)
        return label
    }()
    
    let counter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 50)
        return label
    }()
    
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
        setViewForLobbyClosed()
    }
    
    func changeViewForFullscreen() {
        title.font = title.font.withSize(30)
        subtitle.font = subtitle.font.withSize(20)
        counter.font = counter.font.withSize(80)
    }
    
    func setupCountDown(currentDate: Date, nextGame: Date) {
        self.countdown = GameCountdown(currentDate: currentDate, targetDate: nextGame)
        self.updateTime(TimeInterval(0))
        self.countdownTimer = CustomTimer(handler: { elapsed in
            self.updateTime(elapsed)
        })
    }
    
    func setViewForLobbyOpen() {
        patternLayer.isHidden = false
        title.text = "IT'S TIME"
        counter.text = "Lobby Open!"
        subtitle.text = "Tap to join"
    }
    
    func setViewForLobbyClosed() {
        patternLayer.isHidden = true
        title.text = "LOBBY OPENS IN"
        subtitle.text = "Lobby opens at 9pm est"
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
        if countdown.isFinished {
            self.title.text = ""
            self.counter.text = "Opening Lobby..."
            self.subtitle.text = ""
            self.countdownTimer?.stop()
        } else {
            countdown.currentDate = countdown.currentDate.addingTimeInterval(elapsed)
            self.counter.text = countdown.timeRemaining
        }
    }
}
