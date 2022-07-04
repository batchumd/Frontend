//
//  GameCountdown.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/2/22.
//

import Foundation

enum CountdownResponse {
    case isFinished
    case result(time: String)
    
    var associatedValue: String {
            get {
                switch self {
                    case  .result(let time): return time
                    default: return "Lobby is Open!"
                }
            }
        }
}

struct GameCountdown {
    
    private static let dateComponentFormatter: DateComponentsFormatter = {
        var formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    var currentDate: Date
    
    var targetDate: Date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: 21)) ?? Date()
    }

    var timeRemaining: CountdownResponse {
    
        if targetDate <= currentDate {
            return .isFinished
        } else {
            let timeRemaining = GameCountdown.dateComponentFormatter.string(from: currentDate, to: targetDate)!
            return .result(time: timeRemaining)
        }
    }
}
