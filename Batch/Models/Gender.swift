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
    case male = "male"
    case female = "female"
    case nonbinary = "nonbinary"
}
