//
//  FirebaseHelpers.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/22/22.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol FirebaseProtocol {
    func uploadImage(reference: String, image: UIImage, complete:@escaping ()->())
    func downloadURL(reference: String, complete:@escaping (String)->())
    func addNewUserToDatabase(userData: User,complete:@escaping ()->())
}

protocol Fetchable {
    static var apiBase: String { get }
}

struct FirebaseHelpers: FirebaseProtocol {
    
    fileprivate let db = Firestore.firestore()
    
    fileprivate let auth = Auth.auth()
    
    fileprivate let storage = Storage.storage()
                         
    func fetch<Model: Fetchable>(_: Model.Type, id: String, completion: @escaping (DocumentSnapshot) -> Void) {
            let docRef = db.collection(Model.apiBase).document(id)
            docRef.addSnapshotListener() { (changeSnapshot, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let change = changeSnapshot {
                    completion(change)
                }
            }
    }
    
    func uploadImage(reference: String, image: UIImage, complete: @escaping () -> ()) {
        
        let storageRef = storage.reference().child(reference)
        if let uploadData = image.jpeg(.low) {
                storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    complete()
                }
            }
    }
    
    func downloadURL(reference: String, complete:@escaping (String)->()) {
        let storageRef = storage.reference().child(reference)
        storageRef.downloadURL(completion: { (url, error) in
            guard let downloadURL = url?.absoluteString else { return }
            complete(downloadURL)
        })
    }
    
    func addNewUserToDatabase(userData: User, complete: @escaping () -> ()) {
        print(userData.convertToDict() ?? nil)
//        db.collection("users").document(getUserID()).setData(userData.convertToDict()) { err in
//            if let err = err {
//                        fatalError("\(err)")
//                    } else {
//                        guard let phoneNumber = userData["phoneNumber"] else {
//                            print("Couldnt get phone number")
//                            fatalError("No Phone Number")
//                        }
//                        self.db.collection("registeredPhones").document(phoneNumber).setData(["uid": self.getUserID()])
//                        print("Document Written Successfully")
//                        complete()
//                    }
//                }
    }
    
    func getUserID() -> String? {
        guard let userUid = auth.currentUser?.uid else { return nil }
        return userUid

    }
}
