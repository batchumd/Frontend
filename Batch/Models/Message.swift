//
//  Message.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/23/22.
//

import Foundation
import FirebaseFirestore

struct Message: Codable {
    
    var sender_id: String
    var content: String
    var created_at: Date

    var sender: User?
    
    var isFromCurrentLoggedInUser: Bool {
        guard let uid = DatabaseManager().getUserID() else { return false }
        return uid == sender_id
    }
    
    init (from: [String: Any]) throws {
        var from = from
        
        let timestamp = from["created_at"] as? Timestamp ?? Timestamp(date: Date())
        from["created_at"] = timestamp.dateValue().timeIntervalSince1970 / 1000
                
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let message = try decoder.decode(Self.self, from: data)
        self = message
    }
    
}
