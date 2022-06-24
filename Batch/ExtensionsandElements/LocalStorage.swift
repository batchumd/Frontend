//
//  LocalStorage.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/23/22.
//

import Foundation

class LocalStorage {
    
    static let shared = LocalStorage()
    
    init(){}
    
    func currentUserData() -> User? {
        do {
            let id = FirebaseHelpers().getUserID()
            if let data = UserDefaults.standard.object(forKey: "User\(id!)Key") as? Data {
                let decoder = JSONDecoder()
                return try decoder.decode(User.self, from: data)
            }
        }
        catch {
            print("Couldn't Fetch User Data")
        }
        return nil
    }
}
