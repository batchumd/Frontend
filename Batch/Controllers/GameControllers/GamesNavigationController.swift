//
//  GamesNavigationController.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/23/22.
//

import UIKit
import AVFAudio

class GamesNavigationController: NavControllerWithGradient {
    
    let pitchControl = AVAudioUnitTimePitch()
    
    let engine = AVAudioEngine()
    
    let countdownVC = CountdownViewController()
    let openLobbyVC = OpenLobbyViewController()
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "batchwhite")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleViewHeightConstraint:NSLayoutConstraint!
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close")?.withTintColor(.white), for: .normal)
        return button
    }()

    init() {
        super.init(navigationBarClass: nil, toolbarClass: nil)
        setupNavigationBar()
        setupGradient()
        animateGradient()
        LocalStorage.shared.delegate = self
        lobbyOpenChanged()
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let vcs = [countdownVC, openLobbyVC]
        vcs.forEach({ vc in
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.closeButton)
            vc.navigationItem.titleView = titleImageView
            vc.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        })
        closeButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
    }
    
    func pushToOpenLobby() {
        playSound(resourceName: "lobbyOpenSound")
        self.pushViewController(openLobbyVC, animated: false)
    }
    
    func pushToCoundownController() {
        playSound(resourceName: "countdown")
        self.pushViewController(countdownVC, animated: false)
    }
    
    @objc fileprivate func dismissController() {
        self.dismiss(animated: true) {
            if self.visibleViewController == self.openLobbyVC {
                guard let user = LocalStorage.shared.currentUserData else { return }
                NetworkManager().removeUserFromQueue(gender: user.gender) { error in
                    if let error = error {
                        print(error)
                        return
                    }
                    LocalStorage.shared.userInQueue = false
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GamesNavigationController: LocalStorageDelegate {

    func lobbyOpenChanged() {
        guard let lobbyOpen = LocalStorage.shared.lobbyOpen else { return }
        if lobbyOpen {
            FirebaseHelpers().getGameStartCountdown { countdown in
                let endsAt = countdown.startedAt.timeIntervalSince1970 + countdown.seconds
                let difference = floor(endsAt - Date().timeIntervalSince1970)
                let seconds = Int(floor(difference))
                if !(seconds < 0) {
                    self.openLobbyVC.setupCountdown(countdown)
                    self.pushToOpenLobby()
                }
            }
        } else {
            if (visibleViewController == openLobbyVC) {
                if LocalStorage.shared.userInQueue {
                    print("Show games")
                } else {
                    self.dismiss(animated: true)
                }
            } else {
                self.pushToCoundownController()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.stopSound()
    }
    
}

extension GamesNavigationController {
    fileprivate func playSound(resourceName: String) {
        do {
            guard let url = Bundle.main.url(forResource: resourceName, withExtension: "mp3") else { return }
            engine.stop()
            let file = try AVAudioFile(forReading: url)
            let audioPlayer = AVAudioPlayerNode()
            let audioFormat = file.processingFormat
            let audioFrameCount = UInt32(file.length)
            let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            try! file.read(into: audioFileBuffer!)
            
            let mainMixer = engine.mainMixerNode
            engine.attach(audioPlayer)
            engine.attach(pitchControl)
            engine.connect(audioPlayer, to: mainMixer, format: audioFileBuffer?.format)
            engine.connect(audioPlayer, to: pitchControl, format:audioFileBuffer?.format)
            engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)
            
            try engine.start()
            audioPlayer.play()
            audioPlayer.rate = 0.40
            audioPlayer.scheduleBuffer(audioFileBuffer!, at: nil, options: .loops, completionHandler: nil)
        } catch {
            print(error)
        }
    }
    
    fileprivate func stopSound() {
        engine.stop()
    }
}
