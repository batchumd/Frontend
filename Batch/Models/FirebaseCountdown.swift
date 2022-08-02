//
//  FirebaseCountdown.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/23/22.
//

import FirebaseDatabase

struct FirebaseCountdown {
    var startedAt: Date
    var seconds: Double
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        let t = snapshotValue["startAt"] as! TimeInterval
        self.startedAt = Date(timeIntervalSince1970: t/1000)
        self.seconds = snapshotValue["seconds"] as! Double
    }
}
