//
//  GamesNavigationController.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/23/22.
//

import UIKit
import AVFAudio

class GamesNavigationController: NavControllerWithGradient {
                
    let pointsLabelForBar = PointsLabelBarView(darkMode: true)
    let schoolViewForBar = SchoolBarView(darkMode: true)
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "batchwhite")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleViewHeightConstraint:NSLayoutConstraint!
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close")?.withTintColor(.white), for: .normal)
        return button
    }()

    init() {
        super.init(navigationBarClass: nil, toolbarClass: nil)
        setupGradient()
        animateGradient()
        getUserLobbyData()
    }
    
    fileprivate func setupNavigationBar(vc: UIViewController) {
        
        if vc is CountdownViewController {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: schoolViewForBar)
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        }
        
        if vc is FindGameController {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: schoolViewForBar)
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pointsLabelForBar)
        }
        
        if vc is GameViewController {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: schoolViewForBar)
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pointsLabelForBar)
        }
        
        vc.navigationItem.titleView = titleImageView
        vc.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        vc.navigationItem.setHidesBackButton(true, animated: false)
        closeButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
    }
    
    func pushToCoundownController() {
        let countdownVC = CountdownViewController()
        setupNavigationBar(vc: countdownVC)
        self.pushViewController(countdownVC, animated: false)
        self.removeAllViewControllers()
    }
    
    func pushToFindGameController(_ gameIDs: [String]) {
        let findGameVC = FindGameController(gameIDs: gameIDs)
        self.setupNavigationBar(vc: findGameVC)
        self.pushViewController(findGameVC, animated: false)
        self.removeAllViewControllers()
    }
    
    func pushToGameController(_ gameID: String) {
        let gameVC = GameViewController(gameID: gameID)
        self.setupNavigationBar(vc: gameVC)
        self.pushViewController(gameVC, animated: false)
        self.removeAllViewControllers()
    }
    
    func removeAllViewControllers() {
        var navigationArray = self.viewControllers // To get all UIViewController stack as Array
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!) //To remove all previous UIViewController except the last one
        self.navigationController?.viewControllers = navigationArray
    }
    
    @objc fileprivate func dismissController() {
        self.dismiss(animated: true) {
            guard let userInQueue = LocalStorage.shared.userInQueue else { return }
            if userInQueue {
                guard let user = LocalStorage.shared.currentUserData else { return }
                NetworkManager().removeUserFromQueue(gender: user.gender) { error in
                    if let error = error {
                        print(error)
                        return
                    }
                    LocalStorage.shared.userInQueue = false
                }
            }
        }
    }
    
    fileprivate func getUserLobbyData() {
        guard let gender = LocalStorage.shared.currentUserData?.gender else { return }
        
        DatabaseManager().getUserLobbyData(complete: { data in
            if let data = data {
                LocalStorage.shared.userInQueue = true
                if gender == .bachelorette {
                    if let gameID = data["game_id"] as? String {
                        self.pushToGameController(gameID)
                    }
                } else if gender == .bachelor {
                    if let gameOptions = data["game_options"] as? [String] {
                        self.pushToFindGameController(gameOptions)
                    }
                }
            } else {
                LocalStorage.shared.userInQueue = false
            }
        })
    }
    
    @objc func showCollegeAlert() {
        self.present(schoolViewForBar.alert, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
