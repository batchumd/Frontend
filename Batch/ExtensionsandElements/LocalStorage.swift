//
//  LocalStorage.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/23/22.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol LocalStorageDelegate: AnyObject {
    func userDataChanged()
    func lobbyOpenChanged()
}

extension LocalStorageDelegate {
    func lobbyOpenChanged() {}
    func userDataChanged() {}
}

class LocalStorage {
    
    static let shared = LocalStorage()
    
    init(){}
    
    weak var delegate: LocalStorageDelegate?
    
    var currentUserData: User? {
        didSet {
            delegate?.userDataChanged()
        }
    }
    
    var lobbyOpen: Bool? {
        didSet {
            delegate?.lobbyOpenChanged()
        }
    }
    
    var userInQueue: Bool = false
    
    var serverDate: Date?
    
    var lobbyCountdown: FirebaseCountdown?
    
//    func registrationData() -> [String: Any]? {
//        do {
//            let testFromDefaults = UserDefaults.standard.object([String: Any].self, with: "RegistrationData")
//            if let data = UserDefaults.standard.object(forKey: "RegistrationData") as? Data {
//                let decoder = JSONDecoder()
//                return try decoder.decode([String: Any].self, from: data)
//            }
//        }
//        catch {
//            print("Couldn't Fetch User Data")
//        }
//        return nil
//    }
}
