//
//  VerificationLinkViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/4/22.
//

import Foundation
import UIKit

class VerificationLinkViewController: RegistrationViewController {
        
    //MARK: UI Elements
    fileprivate let awaitingVerificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Awaiting Verification"
        label.font = UIFont(name: "Brown-bold", size: 25)
        label.textColor = .white
        return label
    }()
    
    fileprivate let loadingIndicator = ProgressView(lineWidth: 8)
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        titleLabel.text = "Confirm your email."
        subtitleLabel.text = "We sent an email containing a link that will verify your login."
        informationLabel.text = "This link allows us to confirm your status as a UMD student."
        setupView()
        continueButton.addTarget(self, action: #selector(showNameInputController), for: .touchUpInside)
        self.setupGradient()
        self.animateGradient()
        let loadingIndicatorContainer = UIView()
        self.mainStackView.insertArrangedSubview(loadingIndicatorContainer, at: 2)
        self.loadingIndicator.heightAnchor.constraint(equalToConstant: 75).isActive = true
        loadingIndicatorContainer.addSubview(loadingIndicator)
        loadingIndicator.topAnchor.constraint(equalTo: loadingIndicatorContainer.topAnchor).isActive = true
        loadingIndicator.bottomAnchor.constraint(equalTo: loadingIndicatorContainer.bottomAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: loadingIndicatorContainer.centerXAnchor).isActive = true
        loadingIndicator.widthAnchor.constraint(equalTo: loadingIndicatorContainer.heightAnchor).isActive = true
        
        self.loadingIndicator.animateStroke()
        self.loadingIndicator.animateRotation()
                
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Business Logic
    @objc func showNameInputController() {
        let vc = NameInputViewController()
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc func applicationWillEnterForeground(_ notification: Notification) {
        self.loadingIndicator.animateStroke()
        self.loadingIndicator.animateRotation()
        
    }
    
}
