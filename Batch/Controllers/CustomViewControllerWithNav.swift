//
//  CustomViewControllerWithNav.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class CustomViewControllerWithNav: UIViewController {
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "BatchLogo")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupPointsLabel()
    }
    
    func setupNavigationBar() {
        navigationItem.titleView = titleImageView
        navigationController?.view.backgroundColor = .white
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false

        let myBatches = UIButton()
        myBatches.setImage(UIImage(named: "MessagesIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myBatches)
    }
    
    fileprivate func setupPointsLabel() {
        let pointsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        pointsLabel.text = "2350"
        pointsLabel.textAlignment = .right
        pointsLabel.font = UIFont(name: "GorgaGrotesque-Bold", size: 23)
        pointsLabel.textColor = UIColor(named: "mainColor")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pointsLabel)
    }
}
