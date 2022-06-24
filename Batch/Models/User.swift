//
//  User.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/23/22.
//

import Foundation
import UIKit
import FirebaseFirestore

struct User: Convertable {
    var email: String?
    var name: String?
    var points: Int?
    var age: Int?
    var gender: Gender?
    var dob: Date?
    var interestedIn: [Gender]?
    var profileImages: [String]?
    var uid: String?
    var roundsPlayed: Int?
    var gamesWon: Int?
    
    init? (from: [String: Any]? = nil) throws {
        if var from = from {
            let now = Date()
            let birthday: Date = (from["dob"] as! Timestamp).dateValue()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
            from["age"] = ageComponents.year!
            from.removeValue(forKey: "dob")
            let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
            let decoder = JSONDecoder()
            self = try decoder.decode(Self.self, from: data)
        }
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
