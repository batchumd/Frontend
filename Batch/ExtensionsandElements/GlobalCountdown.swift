//
//  GlobalCountdown.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/5/22.
//

import Foundation

protocol CountdownDelegate: AnyObject {
    func countdownUpdated()
    func statusChanged(isFinished: Bool)
}

class GlobalCountdown {
    
    var countdown: Countdown?
        
    var countdownTimer: CustomTimer?
    
    static let shared = GlobalCountdown()
    
    weak var delegate: CountdownDelegate?
    
    private init() {
        self.handleCountdownToNextLobbyOpen()
    }
    
    func handleCountdownToNextLobbyOpen() {
        self.countdownTimer = CustomTimer(handler: { elapsed in
            self.updateTime(elapsed)
        })
        NetworkManager().getCurrentTime { time, error in
            guard let time = time else { return }
            LocalStorage.shared.serverTime = time
            DatabaseManager().listenForNextGameTime { nextDate in
                DispatchQueue.main.async {
                    self.countdown = Countdown(currentDate: time, endsAt: nextDate)
                }
            }
        }
    }
    
    @objc func updateTime(_ elapsed: TimeInterval) {
        
        if self.countdown != nil {
            self.countdown!.currentDate = self.countdown!.currentDate + elapsed
            
            self.delegate?.countdownUpdated()
            
            self.delegate?.statusChanged(isFinished: self.countdown!.isFinished)
        }
        
    }
    
}
