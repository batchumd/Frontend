//
//  CustomViewControllerWithNav.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class CustomNavController: UINavigationController {
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "BatchLogo")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let pointsLabel = UILabel(frame: CGRect(x: 0, y: -10, width: 75, height: 30))
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        if let root = self.viewControllers.first {
            root.navigationItem.titleView = titleImageView
            root.navigationController?.view.backgroundColor = .white
            root.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
            root.navigationController?.navigationBar.isHidden = false
            root.navigationController?.navigationBar.isTranslucent = false
        }
        setupCollegeButton()
        setupPointsLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupPointsLabel() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 30 ))
        pointsLabel.text = "0"
        pointsLabel.textAlignment = .right
        pointsLabel.font = UIFont(name: "GorgaGrotesque-Bold", size: 25)
        pointsLabel.textColor = UIColor(named: "mainColor")
        container.addSubview(pointsLabel)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 75, height: 30))
        titleLabel.text = "Points"
        titleLabel.textAlignment = .right
        titleLabel.font = UIFont(name: "Brown-Bold", size: 15)
        titleLabel.textColor = UIColor.systemGray2
        container.addSubview(titleLabel)
        self.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: container)
    }
    
    fileprivate func setupCollegeButton() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 32))
        container.layer.cornerRadius = 10
        container.backgroundColor = UIColor(red: 209/255, green: 57/255, blue: 62/255, alpha: 1.0)
        let schoolLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 32))
        schoolLabel.text = "UMD"
        schoolLabel.textAlignment = .center
        schoolLabel.font = UIFont(name: "Gilroy-Extrabold", size: 16)
        schoolLabel.textColor = .white
        container.addSubview(schoolLabel)
        self.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: container)
        let tapCollegeButton = UITapGestureRecognizer(target: self, action: #selector(self.showCollegeAlert))
        container.addGestureRecognizer(tapCollegeButton)
    }
    
    @objc func showCollegeAlert() {
        let alert = UIAlertController(title: "You're on Batch@UMD", message: "You're a player at University of Maryland (Go Terps!). Batch servers are segmented by school. More schools coming soon!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
