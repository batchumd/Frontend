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
