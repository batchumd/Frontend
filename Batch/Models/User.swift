//
//  User.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/23/22.
//

import Foundation
import UIKit

struct User: Convertable {
    var email: String?
    var name: String?
    var age: Int?
    var points: Int?
    var dob: Date?
    var gender: Gender?
    var interestedIn: [Gender]?
    var profileImages: [String]?
    var uid: String?
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
    
}
