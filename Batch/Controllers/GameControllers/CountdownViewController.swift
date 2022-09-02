//
//  CountdownViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/27/22.
//

import UIKit
import AVFAudio
import NotificationBannerSwift

class CountdownViewController: UIViewController {
        
    var secondsCounted = 0
    
    var infoTitleIndex = 0
    
    let infoTitles = [
        "Welcome to the lobby",
        "We’re starting soon",
        "Tip: Just be yourself",
        "Invite friends\nto earn points",
        "Get ready to be the bachelor/ette",
        "Remember to just have fun",
        "Earn points for escaping elimination",
        "Get the gang together",
        "Maybe you'll be chosen to host?",
        "The hottest party on campus"
    ]
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-Extrabold", size: 40)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
        
    //MARK: UI Elements
    let countdownView = CountdownView(isFullscreen: true)
    
    //MARK: UI Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalCountdown.shared.delegate = self
        self.countdownUpdated()
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        LocalStorage.shared.delegate = self
        lobbyStateChanged()
        setupCountdownView()
    }
    
    fileprivate func setupCountdownView() {
        self.view.addSubview(countdownView)
        countdownView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        countdownView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        countdownView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        self.view.addSubview(self.infoLabel)
        infoLabel.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 15, right: 25))
    }
    
}

extension CountdownViewController: CountdownDelegate {
    
    func statusChanged(isFinished: Bool) {
        if isFinished {
            self.countdownView.counter.text = "0"
        }
    }
    
    func countdownUpdated() {
        guard let countdown = GlobalCountdown.shared.countdown else { return }
        if self.secondsCounted % 5 == 0 || self.secondsCounted == 0 {
            if self.infoTitleIndex >= (self.infoTitles.count - 1) {
                self.infoTitleIndex = 0
            }
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.infoLabel.transform = .init(scaleX: 0.1, y: 0.1)
            }) { (finished: Bool) -> Void in
                self.infoLabel.text = self.infoTitles[self.infoTitleIndex]
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.infoLabel.transform = .identity
                })
            }
            self.infoTitleIndex = self.infoTitleIndex + 1
        }
        self.secondsCounted = self.secondsCounted + 1
        if countdown.allowedUnits == [.minute, .second] {
            self.countdownView.counter.font = self.countdownView.counter.font.withSize(105)
        }
        if countdown.allowedUnits == [.second] {
            self.countdownView.counter.font = self.countdownView.counter.font.withSize(130)
        }
        self.countdownView.counter.text = countdown.timeRemaining
    }
}

extension CountdownViewController: LocalStorageDelegate {

    fileprivate func addUserToQueue() {
        NetworkManager().addUserToQueue() { error in
            DispatchQueue.main.async {
                LocalStorage.shared.userInQueue = true
            }
        }
    }
    
    func lobbyStateChanged() {
        
        guard let lobbyState = LocalStorage.shared.lobbyState else { return }
        
        if lobbyState == .open {
            addUserToQueue()
            self.countdownView.subtitle.text = ""
        }
        
        if lobbyState == .waiting {
            
        }
        
        if lobbyState == .find {
            getUserLobbyData()
        }
        
    }
    
    fileprivate func getUserLobbyData() {
        
               guard let gender = LocalStorage.shared.currentUserData?.gender else { return }
               
               DatabaseManager().getUserLobbyData(complete: { data in
                   if let data = data {
                       LocalStorage.shared.userInQueue = true
                       if gender == .bachelorette {
                           if let gameID = data["game_id"] as? String {
                               let nav = self.navigationController as? GamesNavigationController
                               nav?.pushToGameController(gameID)
                    }
                } else if gender == .bachelor {
                    if let gameOptions = data["game_options"] as? [String] {
                        let nav = self.navigationController as? GamesNavigationController
                        nav?.pushToFindGameController(gameOptions)
                    }
                }
            } else {
                LocalStorage.shared.userInQueue = false
            }
        })
    }
    
}

class CustomBannerColors: BannerColorsProtocol {
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
            case .danger: return UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            case .success: return UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
            case .info: return UIColor(named: "mainColor")!
            default: return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        }
    }
}
