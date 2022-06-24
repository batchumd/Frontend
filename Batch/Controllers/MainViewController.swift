//
//  MainViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/19/22.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    
    let homeController = HomeController()
    
    let messagesController = MessagesViewController()
    
    let standingsViewController = RankingsViewController()
    
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
        setupNavigationBar()
        setupTabBar()
        
        guard let uid = FirebaseHelpers().getUserID() else {
            present(SignedOutViewController(), animated: true)
            return
        }
        
        FirebaseHelpers().fetchUserData(uid) { (userData) in
            if let userData = userData {
                userData.saveToDefaults(forKey: "User\(uid)Key") {
                    guard let user = LocalStorage.shared.currentUserData() else {
                        return
                    }
                    
                    self.setupPointsLabel(points: user.points ?? 0)
                    
                    let profileBox = self.homeController.profileBoxView
                    profileBox.nameAgeLabel.text = "\(user.name ?? "User"), \(user.age ?? 0)"
                    profileBox.roundsStatBox.statValue = user.roundsPlayed ?? 0
                    profileBox.wonStatBox.statValue = user.gamesWon ?? 0
                    profileBox.pointsStatBox.statValue = user.points ?? 0
                    self.homeController.profileBoxView.profileImageView.setCachedImage(urlstring: user.profileImages?[0] ?? "", size: profileBox.profileImageView.frame.size) {
                        
                    }
                }
            }
        }
    }
    
    func setupNavigationBar() {
        navigationItem.titleView = titleImageView
        navigationController?.view.backgroundColor = .white
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
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
        setViewControllers([homeController, standingsViewController, messagesController], animated: false)
    }
    
    fileprivate func setupPointsLabel(points: Int) {
        let pointsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        pointsLabel.text = String(points)
        pointsLabel.textAlignment = .right
        pointsLabel.font = UIFont(name: "GorgaGrotesque-Bold", size: 25)
        pointsLabel.textColor = UIColor(named: "mainColor")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pointsLabel)
    }
}
