//
//  MainViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/19/22.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "BatchLogo")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let homeController = HomeController()
    let messagesController = MessagesViewController()
    let standingsViewController = StandingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.16
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 10
        setViewControllers([homeController, messagesController, messagesController], animated: false)

    }
    
     func setupNavigationBar() {
        navigationItem.titleView = titleImageView
        navigationController?.view.backgroundColor = .white
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false

        let myBatches = UIButton()
//      myBatches.addTarget(self, action: #selector(showPlans), for: .touchUpInside)
        myBatches.setImage(UIImage(named: "MessagesIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myBatches)
    }
}
