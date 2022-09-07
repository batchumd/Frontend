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
    func lobbyStateChanged()
    func userInQueueChanged()
}

extension LocalStorageDelegate {
    func lobbyStateChanged() {}
    func userDataChanged() {}
    func userInQueueChanged() {}
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
    
    var lobbyState: LobbyState? {
        didSet {
            delegate?.lobbyStateChanged()
        }
    }
    
    var userInQueue: Bool? {
        didSet {
            delegate?.userInQueueChanged()
        }
    }
    
    var serverTime: TimeInterval?
    
        
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
