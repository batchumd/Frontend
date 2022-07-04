//
//  Settings.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/29/22.
//

import Foundation

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
    var result: [SettingOption]? { get }
}


enum SettingsSection: Int, CaseIterable, CustomStringConvertible{

    case profile
    case notifications
    case auth
    
    var description: String {
        switch self {
            case .profile: return "Profile"
            case .notifications: return "Notifications"
            case .auth: return "Account"
        }
    }
}

enum ProfileSetting: Int, CaseIterable, SectionType, CustomStringConvertible {

    case photos
    case interestedIn
    case gender
    
    var containsSwitch: Bool { return false }
    
    var result: [SettingOption]? {
        guard let userData = LocalStorage.shared.currentUserData() else { return nil }
        switch self {
            case .photos: return nil
            case .interestedIn: return userData.interestedIn
            case .gender: return [userData.gender!]
        }
    }
    
    var description: String {
        switch self {
            case .photos: return "Photos"
            case .interestedIn: return "Interested In"
            case .gender: return "Gender"
        }
    }
}

enum NotificationsSetting: Int, CaseIterable, SectionType, CustomStringConvertible {
    
    case gameTime
    case messages
    
    var containsSwitch: Bool { return true }
    
    var result: [SettingOption]? { return nil }
    
    var description: String {
        switch self {
            case .gameTime: return "Game times"
            case .messages: return "Messages"
        }
    }
}

enum AuthSetting: Int, CaseIterable, SectionType, CustomStringConvertible {
    
    case signOut
    case deleteAccount
    
    var containsSwitch: Bool { return false }
    
    var result: [SettingOption]? { return nil }

    var description: String {
        switch self {
            case .signOut: return "Sign Out"
            case .deleteAccount: return "Delete Account"
        }
    }
}
