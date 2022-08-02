//
//  CountdownViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/27/22.
//

import UIKit
import AVFAudio

class CountdownViewController: UIViewController {
        
    //MARK: UI Elements
    let countdownView = CountdownView(isFullscreen: true)
    
//    var notifyButton: UIButton = {
//        if #available(iOS 15.0, *) {
//            var filled = UIButton.Configuration.filled()
//            filled.buttonSize = .large
//            filled.imagePlacement = .leading
//            filled.imagePadding = 5
//            filled.baseBackgroundColor = .white
//            filled.attributedTitle = AttributedString(NSAttributedString(string: "Notify Me", attributes: [
//                    .font: UIFont(name: "Gilroy-ExtraBold", size: 20)!,
//                    .foregroundColor: UIColor(named: "mainColor")!]))
//            filled.image = UIImage(named: "bell")!.withTintColor(UIColor(named: "mainColor")!)
//            let button = UIButton(configuration: filled, primaryAction: nil)
//            let handler: UIButton.ConfigurationUpdateHandler = { button in
//                switch button.state {
//                case .selected:
//                    button.alpha = 1
//                default:
//                    button.alpha = 0.5
//                }
//            }
//            button.configurationUpdateHandler = handler
//            return button
//        } else {
//            return UIButton()
//        }
//    }()
    
    //MARK: UI Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setupCountdownView()
        setupNavigationBar()
    }
    
    fileprivate func setupCountdownView() {
        self.view.addSubview(countdownView)
        countdownView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        countdownView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        countdownView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    fileprivate func setupNavigationBar() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.notifyButton)
//        notifyButton.addTarget(self, action: #selector(notifyButtonPressed), for: .touchUpInside)
    }


    
    @objc fileprivate func notifyButtonPressed() {
//        if notifyButton.isSelected {
//            notifyButton.isSelected = false
//        } else {
//            notifyButton.isSelected = true
//        }
    }
}
