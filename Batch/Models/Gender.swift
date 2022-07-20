//
//  Gender.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation

protocol SettingOption {
    var rawValue: String { get }
}

enum Gender: String, CaseIterable, Codable, SettingOption {
    
    case bachelor = "bachelor"
    case bachelorette = "bachelorette"
    
    var pluralized: String {
            switch self {
            case .bachelor: return "Bachelors"
            case .bachelorette: return "Bachelorettes"
        }
    }
    
}
