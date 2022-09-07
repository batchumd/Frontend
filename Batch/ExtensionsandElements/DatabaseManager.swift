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
import FirebaseDatabase

protocol AccountManagement {
    func addNewUserToDatabase(userData: [String: Any], complete: @escaping (Error?)->())
    func fetchUserData(_ uid: String, listen: Bool, completionHandler: @escaping (_ userData: User?) -> ())
    func signOutUser(complete: @escaping (Error?) -> ())
    func getUserID() -> String?
    func deleteCurrentUser(complete: @escaping (_ error: Error?) -> ())
    func modifyUserImage(_ imageURL: String, delete: Bool, complete: @escaping (Error?)->())
    func updateUserData(data: [String: Any], complete: @escaping (Error?)->())
}

protocol ImageManagement {
    func uploadImage(reference: String, image: UIImage, complete: @escaping () -> ())
    func downloadURL(reference: String, complete:@escaping (String)->())
}

protocol GameManagement {
    func listenForLobbyStatus()
    func getGameOptions(complete: @escaping (_ gameOptions: [String]?) -> ())
    func getUserLobbyData(complete: @escaping (_ lobbyData: [String: Any]?)->())
    func fetchGameInfo(_ gameID: String, listen: Bool, complete: @escaping (_ gameInfo: Game?) -> ())
    func listenGamesOngoingStatus(complete: @escaping (_ gamesOngoing: Bool) -> ())
    func getGameStartCountdown(complete: @escaping (_ countDown: Countdown?) -> ())
    func listenForNextGameTime(complete: @escaping (_ time: TimeInterval) -> ())
    func addResponse(gameID: String, content: String, complete: @escaping ()->())
    func setQuestionForGame(gameID: String, question: String, complete: @escaping () -> ())
    func fetchQuestions(complete: @escaping (_ questions: [String]) -> ())
    func setGameCountdown(gameID: String, countdown: Countdown, complete: @escaping () -> ())
    func startRoundOne(gameID: String, complete: @escaping (Error?) -> ())
}

protocol Fetchable {
    static var apiBase: String { get }
}

// MARK: Initialize singleton class
final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    fileprivate let matchmakingDB = Database.database(url: "https://batch-24ec0-match-queue.firebaseio.com/")
    
    fileprivate let firestore = Firestore.firestore()
    
    fileprivate let auth = Auth.auth()
    
    fileprivate let storage = Storage.storage()

}

// MARK: returns document at childpath from firestore
extension DatabaseManager {
    func fetch<Model: Fetchable>(_: Model.Type, listen: Bool, id: String, completion: @escaping (DocumentSnapshot) -> ()) {
        let docRef = firestore.collection(Model.apiBase).document(id)
        if listen {
            docRef.addSnapshotListener() { (changeSnapshot, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let change = changeSnapshot {
                    completion(change)
                }
            }
        } else {
            docRef.getDocument { documentSnapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                if let documentSnapshot = documentSnapshot {
                    completion(documentSnapshot)
                }
            }
        }
    }
}

// MARK: Account Management
extension DatabaseManager: AccountManagement {
    
    func addNewUserToDatabase(userData: [String: Any], complete: @escaping (Error?)->()) {
        guard let uid = getUserID() else { return }
        firestore.collection("users").document(uid).setData(userData) { error in
            
            if let error = error {
                complete(error)
                return
            }
            
            complete(nil)
        }
    }
    
    func fetchUserData(_ uid: String, listen: Bool, completionHandler: @escaping (_ userData: User?) -> ()) {
        fetch(User.self, listen: listen, id: uid) { (snapshot) in
            if snapshot.exists {
                if var data = snapshot.data() {
                    do {
                        data["uid"] = snapshot.documentID
                        let user = try User.init(from: data)
                        completionHandler(user)
                    } catch {
                        completionHandler(nil)
                    }
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func signOutUser(complete: @escaping (Error?) -> ()) {
        do {
            try auth.signOut()
            SceneSwitcher.shared.updateRootVC()
        } catch let signOutError {
            complete(signOutError)
        }
    }
    
    func getUserID() -> String? {
        guard let userUid = auth.currentUser?.uid else {
            SceneSwitcher.shared.updateRootVC()
            return nil
        }
        return userUid
    }
    
    func deleteCurrentUser(complete: @escaping (_ error: Error?) -> ()) {
        
        guard let uid = getUserID() else { return }
        
        // First delete the user images
        self.deleteUserImages { error in
            
            if let error = error {
                complete(error)
                return
            }
            
            // If deletion of images succeeds delete the user from the auth
            self.auth.currentUser?.delete(completion: { error in
                if let error = error {
                    complete(error)
                    return
                }
                
                // If user is deleted from auth successfully remove them from firestore
                self.firestore.collection("users").document(uid).delete { error in
                    if let error = error {
                        complete(error)
                        return
                    }
                    print("User data deleted")
                    SceneSwitcher.shared.updateRootVC()
                }
            })
        }
        
    }
    
    func deleteUserImages(url: String? = nil, complete: @escaping (Error?) -> ()) {
        // Check if the image is manually selected for deletion
        if let url = url {
            let storageRef = storage.reference(forURL: url)
            storageRef.delete { error in
                if let error = error {
                    complete(error)
                    return
                }
                self.modifyUserImage(url, delete: true) { error in
                    if let error = error {
                        complete(error)
                        return
                    }
                    complete(nil)
                }
            }
        } else {
            // Delete all user images
            guard let userImages = LocalStorage.shared.currentUserData?.profileImages else { return }
            for imageURL in userImages {
                let storageRef = storage.reference(forURL: imageURL)
                storageRef.delete { error in
                    if let error = error {
                        complete(error)
                    }
                    complete(nil)
                }
            }
        }
    }
    
    func modifyUserImage(_ imageURL: String, delete: Bool, complete: @escaping (Error?)->()) {
        
        guard let uid = getUserID() else { return }

        let userRef = firestore.collection("users").document(uid)
        
        var profileImagesData: [String: Any]
        
        if delete {
            profileImagesData = ["profileImages": FieldValue.arrayRemove([imageURL])]
        } else {
            profileImagesData = ["profileImages": FieldValue.arrayUnion([imageURL])]
        }
                
        userRef.updateData(profileImagesData) { error in
            if let error = error {
                complete(error)
                return
            }
            complete(nil)
        }
    }
    
    func updateUserData(data: [String: Any], complete: @escaping (Error?)->()) {
        
        guard let uid = getUserID() else { return }
      
        let userRef = firestore.collection("users").document(uid)
        
        userRef.updateData(data) { (error) in
            if let error = error {
                complete(error)
            }
            complete(nil)
        }
    }
}

// MARK: Image Management
extension DatabaseManager: ImageManagement {
    
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
    
}

// MARK: Game Management
extension DatabaseManager: GameManagement {
    
    func listenForUserInQueue() {
        guard let uid = self.getUserID() else { return }
        guard let user = LocalStorage.shared.currentUserData else { return }
        matchmakingDB.reference(withPath: "matchmaking/\(user.gender)/\(uid)").observe(.value) { snapshot in
            if snapshot.exists() {
                LocalStorage.shared.userInQueue = true
            } else {
                LocalStorage.shared.userInQueue = false
            }
        }
    }
        
    func listenForLobbyStatus() {
        matchmakingDB.reference(withPath: "properties").child("lobby_state").observe(.value) { snapshot in
            guard let value = snapshot.value as? String else { return }
            LocalStorage.shared.lobbyState = LobbyState(rawValue: value)
        }
    }
    
    func getGameOptions(complete: @escaping (_ gameOptions: [String]?) -> ()) {
        
        guard let user = LocalStorage.shared.currentUserData else { return }
        guard let uid = getUserID() else { return }
        
        matchmakingDB.reference(withPath: "matchmaking/\(user.gender)/\(uid)/game_options").getData { error, snapshot in

            guard let gameOptions = snapshot!.value as? [String] else {
                complete(nil)
                return
            }
            
            complete(gameOptions)
            
        }
        
    }
    
    func getUserLobbyData(complete: @escaping (_ lobbyData: [String: Any]?)->()) {
        guard let user = LocalStorage.shared.currentUserData else { return }
        guard let uid = getUserID() else { return }
        
        matchmakingDB.reference(withPath: "matchmaking/\(user.gender)/\(uid)").observe(.value, with: { snapshot in
            if snapshot.exists() {
                complete(snapshot.value as? [String: Any])
            } else {
                complete(nil)
            }
        })
    }
    
    func fetchGameInfo(_ gameID: String, listen: Bool, complete: @escaping (_ gameInfo: Game?) -> ()) {
        fetch(Game.self, listen: listen, id: gameID) { snapshot in
            if snapshot.exists {
                if let data = snapshot.data() {
                    do {
                        let game = try Game.init(from: data)
                        complete(game)
                    } catch {
                        complete(nil)
                    }
                }
            } else {
                complete(nil)
            }
        }
    }
    
    func listenGamesOngoingStatus(complete: @escaping (_ gamesOngoing: Bool) -> ()) {
        matchmakingDB.reference(withPath: "properties").child("games_ongoing").observe(.value) { snapshot in
            guard let value = snapshot.value as? Bool else { return }
            complete(value)
        }
    }
    
    func getGameStartCountdown(complete: @escaping (_ countDown: Countdown?) -> ()) {
        matchmakingDB.reference(withPath: "properties").child("lobby_countdown").getData(completion: { error, snapshot in
            if let error = error {
                print(error)
                complete(nil)
                return
            }
            
            do {
                guard let data = snapshot!.value as? [String: Any] else { return }
                let coded = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let countdown = try decoder.decode(Countdown.self, from: coded)
                complete(countdown)
            } catch {
                complete(nil)
            }
        })
    }
    
    func listenForNextGameTime(complete: @escaping (_ time: TimeInterval) -> ()) {
        matchmakingDB.reference(withPath: "properties").child("next_game").observe(.value, with: { snapshot in
            if snapshot.exists() {
                let timeSince = snapshot.value as! TimeInterval
                complete(timeSince / 1000)
            }
        })
    }
    
    func addResponse(gameID: String, content: String, complete: @escaping ()->()) {
        guard let uid = self.getUserID() else { return }
        firestore.collection("games").document(gameID).collection("responses").document().setData( [
            "sender_id": uid,
            "content": content,
            "created_at": FieldValue.serverTimestamp()
        ], completion: { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            complete()
        })
    }
    
    func setQuestionForGame(gameID: String, question: String, complete: @escaping () -> ()) {
        firestore.collection("games").document(gameID).updateData(["question": question]) { error in
            if let error = error {
                print(error)
                return
            }
            complete()
        }
    }
    
    func fetchQuestions(complete: @escaping (_ questions: [String]) -> ()) {
        matchmakingDB.reference(withPath: "questions").getData(completion: { error, snapshot in
            if let error = error {
                print(error)
                return
            }
            if let snapshot = snapshot {
                guard let questions = snapshot.value as? [String] else { return }
                complete(questions)
            }
        })
    }
    
    func setGameCountdown(gameID: String, countdown: Countdown, complete: @escaping () -> ()) {
        firestore.collection("games").document(gameID).updateData(["timer": countdown.toDict]) { error in
            if let error = error {
                print(error)
                return
            }
            complete()
        }
    }
    
    func startRoundOne(gameID: String, complete: @escaping (Error?) -> ()) {
        
        NetworkManager().startGame(gameID: gameID) { error in
            if let error = error {
                complete(NSError(domain: error, code: 0))
                return
            }
            complete(nil)
        }
    
    }
    
}
