//
//  Gender.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation

enum Gender: String, CaseIterable, Codable {
    case male = "male"
    case female = "female"
    case nonbinary = "nonbinary"
    
    var pluralized: String {
        switch self {
            case .male: return "men"
            case .female: return "women"
            case .nonbinary: return "nonbinary people"
        }
    }
}
