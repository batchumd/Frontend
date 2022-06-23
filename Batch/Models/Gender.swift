//
//  Gender.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation

enum Gender: CaseIterable, Codable {
    case male
    case female
    case nonbinary
    
    var desc: String {
        switch self {
            case .male: return "male"
            case .female: return "female"
            case .nonbinary: return "nonbinary"
        }
    }
    
    var pluralized: String {
        switch self {
            case .male: return "men"
            case .female: return "women"
            case .nonbinary: return "nonbinary people"
        }
    }
}
