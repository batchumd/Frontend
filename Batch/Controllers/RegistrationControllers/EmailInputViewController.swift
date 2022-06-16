//
//  EmailInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/3/22.
//

import UIKit

class EmailInputViewController: RegistrationViewController {
    
    
    //MARK: UI Elements
    let emailInput: ATCTextField = {
        let textField = ATCTextField()
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 170, height: 40))
        label.text = "@terpmail.umd.edu"
        rightView.addSubview(label)
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.textAlignment = .right
        textField.setLeftPadding(20)
        label.font = UIFont(name: "Brown-bold", size: 16)
        label.textColor = UIColor(named: "mainColor")
        textField.font = UIFont(name: "Brown-bold", size: 16)
        textField.textColor = UIColor(named: "mainColor")
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        self.mainStackView.insertArrangedSubview(emailInput, at: 2)
        titleLabel.text = "Enter your UMD \nstudent email."
        subtitleLabel.text = "Batch is currently only available for the University of Maryland community. We plan to launch in more places in the near future!"
        informationLabel.text = "We will never share your email with anyone or display it on your profile."
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
        setupView()
        self.setupGradient()
        self.animateGradient()
    }
    
    //MARK: Business Logic
    @objc func continueButtonClicked() {
        if ValidityChecker().isEmailValid((emailInput.text ?? "") + "@terpmail.umd.edu") {
            showVerificationController()
        } else {
            self.displayError(message: "Please enter a valid email")
        }
    }
    
    func showVerificationController() {
        let vc = VerificationLinkViewController()
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
