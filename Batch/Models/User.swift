//
//  User.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/23/22.
//

import Foundation
import UIKit
import FirebaseFirestore

class User: NSObject, Convertable {
    
    var email: String
    var name: String
    var points: Int
    var age: Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: Date(timeIntervalSince1970: self.dob), to: now)
        return ageComponents.year ?? 0
    }
    var gender: Gender
    var dob: TimeInterval
    var profileImages: [String]
    var roundsPlayed: Int
    var gamesWon: Int
    
    init(_ user: User) {
        self.email = user.email
        self.name = user.name
        self.points = user.points
        self.gender = user.gender
        self.dob = user.dob
        self.profileImages = user.profileImages
        self.roundsPlayed = user.roundsPlayed
        self.gamesWon = user.gamesWon
    }
    
    convenience init (from: [String: Any]) throws {
        
        var from = from
        
        if from.contains(where: {$0.key == "dob"}) {
            let dob: Date = (from["dob"] as! Timestamp).dateValue()
            from["dob"] = dob.timeIntervalSince1970
        }
            
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let user = try decoder.decode(Self.self, from: data)
        self.init(user)
    }
                
}

protocol Convertable: Codable {
    
}

extension Convertable {
    
    func convertToDict() -> Dictionary<String, Any>? {

        var dict: Dictionary<String, Any>? = nil

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
            
        } catch {
            print(error)
        }

        return dict
    }
    
    func saveToDefaults(forKey: String, complete: @escaping () -> ()) {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(self)
            UserDefaults.standard.set(json, forKey: forKey)
            
        } catch {
            print(error)
        }
        complete()
    }
}

extension User: Fetchable {
    static var apiBase: String { return "users" }
}
