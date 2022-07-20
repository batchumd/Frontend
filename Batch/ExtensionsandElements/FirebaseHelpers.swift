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
    func addNewUserToDatabase(userData: [String: Any],complete: @escaping ()->())
    func fetchUserData(_ uid: String, completionHandler: @escaping (_ userData: User?) -> ())
    func signOutUser()
    func deleteCurrentUser(complete: @escaping (_ error: Error?) -> ())
    func getCountdownToLive()
    func updateUserData(data: [String: Any], complete: @escaping ()->())
    func addImageToUserData(_ imageURL: String, complete: @escaping ()->())
    func deleteUserImages(url: String?, complete: @escaping () -> ())
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
    
    func addNewUserToDatabase(userData: [String: Any], complete: @escaping ()->()) {
        guard let uid = getUserID() else { return }
        db.collection("users").document(uid).setData(userData) { err in
            if let err = err { fatalError("\(err)") }
            print("Document Written Successfully")
            complete()
        }
    }
    
    func fetchUserData(_ uid: String, completionHandler: @escaping (_ userData: User?) -> ()) {
        fetch(User.self, id: uid) { (snapshot) in
            if snapshot.exists {
                if let data = snapshot.data() {
                    let user = try! User.init(from: data)
                    completionHandler(user)
                }
                //handle
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
            Switcher.shared.updateRootVC()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func getUserID() -> String? {
        guard let userUid = auth.currentUser?.uid else {
            Switcher.shared.updateRootVC()
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
                    Switcher.shared.updateRootVC()
                }
            })
        }
        
    }
    
    func deleteUserImages(url: String? = nil, complete: @escaping () -> ()) {
        if let url = url {
            let storageRef = storage.reference(forURL: url)
            storageRef.delete { error in
                self.removeImageFromUserData(url) {
                    complete()
                }
            }
        } else {
            guard let userImages = LocalStorage.shared.currentUserData?.profileImages else { return }
            for imageURL in userImages {
                let storageRef = storage.reference(forURL: imageURL)
                storageRef.delete { error in
                    complete()
                }
            }
        }
    }
    
    func addImageToUserData(_ imageURL: String, complete: @escaping ()->()) {
        
        guard let uid = getUserID() else { return }

        let userRef = db.collection("users").document(uid)
        
        userRef.updateData([
            "profileImages": FieldValue.arrayUnion([imageURL])
        ]) { error in
            complete()
        }
    }
    
    func removeImageFromUserData(_ imageURL: String, complete: @escaping ()->()) {
        
        guard let uid = getUserID() else { return }

        let userRef = db.collection("users").document(uid)
        
        userRef.updateData([
            "profileImages": FieldValue.arrayRemove([imageURL])
        ]) { error in
            complete()
        }
    }
    
    func updateUserData(data: [String: Any], complete: @escaping ()->()) {
        
        guard let uid = getUserID() else { return }
      
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData(data) { (error) in
            if error == nil {
                complete()
            } else{
                print("not updated")
            }
        }

    }
    
}
