//
//  MainViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/19/22.
//

import Foundation
import UIKit
import NotificationBannerSwift

class MainViewController: UITabBarController {
        
    let homeController = HomeController()
    
    let messagesController = MessagesViewController()
        
    let profileViewController = ProfileViewController(user: LocalStorage.shared.currentUserData)
    
    lazy var vcs = [homeController, messagesController, profileViewController].map({CustomNavController(rootViewController: $0)})
    
    //MARK: UI Elements
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "BatchLogo")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: UI Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!).withAlphaComponent(0.65)
        setupTabBar()
        DatabaseManager.shared.listenForLobbyStatus()
        DatabaseManager.shared.listenForUserInQueue()
    }
    
    fileprivate func setupTabBar() {
        tabBar.tintColor = UIColor(named: "mainColor")
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.16
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 10
        setViewControllers(vcs, animated: false)
        self.tabBar.clipsToBounds = false
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    @objc func showCollegeAlert() {
        let alert = UIAlertController(title: "You're on Batch@UMD", message: "You're a player at University of Maryland (Go Terps!). Batch servers are segmented by school. More schools coming soon!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocalStorage.shared.delegate = self
        userDataChanged()
    }
    
    @objc func handleSignOut() {
        DatabaseManager().signOutUser { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
