//
//  GameCountdown.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/2/22.
//

import Foundation

struct GameCountdown {
        
    private static let dateComponentFormatter: DateComponentsFormatter = {
        var formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var allowedUnits: NSCalendar.Unit = [.hour, .minute, .second]

    var currentDate: Date
    
    var targetDate: Date
    
    var isFinished: Bool {
        if targetDate <= currentDate {
            return true
        } else {
            return false
        }
    }
    
    var timeRemaining: String {
        GameCountdown.dateComponentFormatter.allowedUnits = allowedUnits
        return GameCountdown.dateComponentFormatter.string(from: currentDate, to: targetDate)!
    }
}
