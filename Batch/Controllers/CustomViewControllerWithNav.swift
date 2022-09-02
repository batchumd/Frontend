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
    
    let pointsLabelForBar = PointsLabelBarView(darkMode: false)
    
    let schoolViewForBar = SchoolBarView(darkMode: false)
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        if let root = self.viewControllers.first {
            root.navigationItem.titleView = titleImageView
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
        self.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pointsLabelForBar)
    }
    
    fileprivate func setupCollegeButton() {
        self.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: schoolViewForBar)
        let tapCollegeButton = UITapGestureRecognizer(target: self, action: #selector(self.showCollegeAlert))
        schoolViewForBar.addGestureRecognizer(tapCollegeButton)
    }
    
    @objc func showCollegeAlert() {
        self.present(schoolViewForBar.alert, animated: true)
    }
    
}
