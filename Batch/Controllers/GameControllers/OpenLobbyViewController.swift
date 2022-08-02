//
//  OpenLobbyViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/23/22.
//

import Foundation
import UIKit
import NotificationBannerSwift

class OpenLobbyViewController: UIViewController {
    
    //MARK: UI Elements
    var timerSinceOpen: CustomTimer!
    
    var gameCountdown: GameCountdown!
    
    var countdown: FirebaseCountdown!
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, containerView])
        sv.axis = .vertical
        return sv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let patternLayer = CALayer()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-Extrabold", size: 33)
        label.text = "Starting in"
        return label
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-Extrabold", size: 110)
        return label
    }()

    let currentLobbyCount: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 25))
        let userImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        userImage.image = UIImage(named: "profile")?.withTintColor(.white)
        view.addSubview(userImage)
        let label = UILabel(frame: CGRect(x: 30, y: 0, width: 70, height: 25))
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 27)
        label.text = "103"
        label.textColor = .white
        view.addSubview(label)
        return view
    }()
    
    let activityLabel: UILabel = {
        let label = UILabel()
        label.text = "Adding you to the queue..."
        label.font = UIFont(name: "Brown-bold", size: 22)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let progressIndicator = ProgressView(lineWidth: 5)
    
    let progressIndicatorContainer = UIView()
    
    lazy var activityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.activityLabel, self.progressIndicatorContainer])
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    //MARK: UI Lifecycle Methods
    
    override func viewWillLayoutSubviews() {
//        self.containerView.layoutIfNeeded()
//        self.patternLayer.frame = self.containerView.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.currentLobbyCount)
        
        handleAddUserToQueue()
        
        view.addSubview(stackView)
        stackView.centerInsideSuperView()
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        containerView.heightAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        containerView.addSubview(mainLabel)
        mainLabel.centerInsideSuperView()
        
        patternLayer.contents = UIImage(named: "celebration")?.cgImage
        patternLayer.contentsGravity = .resizeAspect
        containerView.layer.insertSublayer(patternLayer, at: 0)
        
        setupActivityView()
    }
    
    func setupActivityView() {
        view.addSubview(activityStackView)
        activityStackView.anchor(top: containerView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 25, bottom: 0, right: 25))
        progressIndicatorContainer.addSubview(progressIndicator)
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        progressIndicator.topAnchor.constraint(equalTo: progressIndicatorContainer.topAnchor).isActive = true
        progressIndicator.bottomAnchor.constraint(equalTo: progressIndicatorContainer.bottomAnchor).isActive = true
        progressIndicator.centerXAnchor.constraint(equalTo: progressIndicatorContainer.centerXAnchor).isActive = true
        progressIndicator.widthAnchor.constraint(equalTo: progressIndicatorContainer.heightAnchor).isActive = true
        progressIndicator.animateStroke()
        progressIndicator.animateRotation()
    }
    
    //MARK: Business Logic
    @objc func updateTime(_ elapsed: TimeInterval) {
        if (gameCountdown.isFinished) {
            self.timerSinceOpen?.stop()
        } else {
            self.gameCountdown.currentDate = self.gameCountdown.currentDate.addingTimeInterval(elapsed)
            self.mainLabel.text = self.gameCountdown.timeRemaining
        }
    }
    
    func setupCountdown(_ countdown: FirebaseCountdown) {
        let endsAt = countdown.startedAt.timeIntervalSince1970 + countdown.seconds
        self.gameCountdown = GameCountdown(allowedUnits: [.minute, .second], currentDate: Date(), targetDate: Date(timeIntervalSince1970: endsAt))
        self.timerSinceOpen = CustomTimer(handler: { elapsed in
            self.updateTime(elapsed)
        })
    }
    
    fileprivate func handleAddUserToQueue() {
        
        // Unwrap localstorage values
        guard let user = LocalStorage.shared.currentUserData else { return }
        
        NetworkManager().addUserToQueue(gender: user.gender) { error in
            if let error = error {
                print(error)
                LocalStorage.shared.userInQueue = false
                let banner = FloatingNotificationBanner(
                    title: "Failure: You couldn't join the queue",
                    subtitle: nil,
                    style: .danger
                )
                banner.layer.opacity = 0.2
                banner.show(bannerPosition: .bottom, edgeInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), cornerRadius: 16)
                return
            }
            DispatchQueue.main.async {
                LocalStorage.shared.userInQueue = true
                let banner = FloatingNotificationBanner(
                    title: "Success: You were added to the queue",
                    subtitle: nil,
                    titleFont: UIFont(name: "Brown-bold", size: 16),
                    style: .success,
                    colors: CustomBannerColors(),
                    opacity: 0.5
                )
                banner.show(bannerPosition: .bottom, edgeInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), cornerRadius: 16)
                self.activityStackView.removeFromSuperview()
            }
        }
        
    }
}

class CustomBannerColors: BannerColorsProtocol {
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
            case .danger: return UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            case .success: return UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
            default: return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        }
    }
    

}
