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
import Firebase

protocol FirebaseProtocol {
    func uploadImage(reference: String, image: UIImage, complete:@escaping ()->())
    func downloadURL(reference: String, complete:@escaping (String)->())
    func addNewUserToDatabase(userData: User,complete: @escaping ()->())
    func fetchUserData(_ uid: String, completionHandler: @escaping (_ userData: User?) -> ())
    func signOutUser()
    func deleteCurrentUser(complete: @escaping (_ error: Error?) -> ())
    func getCountdownToLive()
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
    
    func addNewUserToDatabase(userData: User, complete: @escaping ()->()) {
        guard let uid = getUserID(), var data = userData.convertToDict() else { return }
        data["dob"] = userData.dob
        db.collection("users").document(uid).setData(data) { err in
            if let err = err { fatalError("\(err)") }
            print("Document Written Successfully")
            complete()
        }
    }
    
    func fetchUserData(_ uid: String, completionHandler: @escaping (_ userData: User?) -> ()) {
        fetch(User.self, id: uid) { (snapshot) in
            if snapshot.exists {
                let user = try! User.init(from: snapshot.data())
                completionHandler(user)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func getCountdownToLive() {
       
    }
    
    func signOutUser() {
        do {
            try auth.signOut()
            Switcher.updateRootVC()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func getUserID() -> String? {
        guard let userUid = auth.currentUser?.uid else {
            Switcher.updateRootVC()
            return nil
        }
        return userUid
    }
    
    func deleteCurrentUser(complete: @escaping (_ error: Error?) -> ()) {
        
        guard let uid = getUserID() else { return }
        
        self.deleteUserImages {
            auth.currentUser?.delete(completion: { error in
                if let error = error {
                    complete(error)
                    return
                }
                db.collection("users").document(uid).delete { error in
                    if let error = error { complete(error) }
                    print("User data deleted")
                    Switcher.updateRootVC()
                }
            })
        }
        
    }
    
    func deleteUserImages(complete: @escaping () -> ()) {
        guard let userImages = LocalStorage.shared.currentUserData()?.profileImages else { return }
        for imageURL in userImages {
            let storageRef = storage.reference(forURL: imageURL)
            storageRef.delete { error in
                complete()
            }
        }
    }
    
    func updateUserData(data: [String: Any]){
        
        guard let uid = getUserID() else { return }
      
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData(data) { (error) in
            if error == nil {
                print("updated")
            } else{
                print("not updated")
            }
            
        }

    }
    
}
