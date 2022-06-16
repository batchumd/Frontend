//
//  CountdownViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/27/22.
//

import UIKit

class CountdownViewController: ViewControllerWithGradient {
    
    let countdownView = CountdownView(fullscreen: true)
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close")?.withTintColor(.white), for: .normal)
        return button
    }()
    
    var notifyButton: UIButton = {
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.buttonSize = .large
            filled.imagePlacement = .leading
            filled.imagePadding = 5
            filled.baseBackgroundColor = .white
            filled.attributedTitle = AttributedString(NSAttributedString(string: "Notify Me", attributes: [
                    .font: UIFont(name: "Gilroy-ExtraBold", size: 20)!,
                    .foregroundColor: UIColor(named: "mainColor")!]))
            filled.image = UIImage(named: "bell")!.withTintColor(UIColor(named: "mainColor")!)
            let button = UIButton(configuration: filled, primaryAction: nil)
            let handler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .selected:
                    button.alpha = 1
                default:
                    button.alpha = 0.5
                }
            }
            button.configurationUpdateHandler = handler
            return button
        } else {
            return UIButton()
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(countdownView)
        countdownView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        countdownView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        countdownView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: notifyButton)
        notifyButton.addTarget(self, action: #selector(notifyButtonPressed), for: .touchUpInside)
    }
    
    @objc fileprivate func dismissViewController() {
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc fileprivate func notifyButtonPressed() {
        if notifyButton.isSelected {
            notifyButton.isSelected = false
        } else {
            notifyButton.isSelected = true
        }
    }
    
}

