//
//  LocalStorage.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/23/22.
//

import Foundation

protocol UserDelegate: AnyObject {
    func userDataChanged()
}

class LocalStorage {
    
    static let shared = LocalStorage()
    
    init(){}
    
    weak var delegate: UserDelegate?
    
    var currentUserData: User? {
        didSet {
            delegate?.userDataChanged()
        }
    }

    
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
