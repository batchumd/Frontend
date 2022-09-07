//
//  GameCountdown.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/2/22.
//

import Foundation

class Countdown: Codable {
    
    enum CodingKeys: String, CodingKey {
        case startedAt = "started_at"
        case seconds = "seconds"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.startedAt = try values.decode(TimeInterval.self, forKey: .startedAt)
        self.seconds = try values.decode(TimeInterval.self, forKey: .seconds)
        self.endsAt = (startedAt! / 1000) + seconds!
    }
        
    private static let dateComponentFormatter: DateComponentsFormatter = {
        var formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var startedAt: TimeInterval?
    var seconds: TimeInterval?
    
    var currentDate: TimeInterval = Date().timeIntervalSince1970
    var endsAt: TimeInterval?
    
    init(currentDate: TimeInterval, endsAt: TimeInterval) {
        self.currentDate = currentDate
        self.endsAt = endsAt
    }
    
    init(startedAt: TimeInterval, seconds: TimeInterval) {
        self.startedAt = startedAt
        self.seconds = seconds
        self.endsAt = (startedAt / 1000) + seconds
    }
    
    var allowedUnits: NSCalendar.Unit {
        
        let secondsRemaining = self.endsAt! - Date().timeIntervalSince1970
        
        if secondsRemaining > 3600 {
            return [.hour, .minute, .second]
        }
        if secondsRemaining > 60 {
            return [.minute, .second]
        }
        
        return [.second]
    }
    
    var isFinished: Bool {
        if endsAt! <= Date().timeIntervalSince1970 {
            return true
        } else {
            return false
        }
    }
    
    var timeRemaining: String {
        Countdown.dateComponentFormatter.allowedUnits = allowedUnits
        return Countdown.dateComponentFormatter.string(from: Date(timeIntervalSince1970: currentDate), to: Date(timeIntervalSince1970: endsAt!))!
    }
    
    var toDict: [String: Any] {
        return ["started_at": self.startedAt, "seconds": self.seconds]
    }
}
