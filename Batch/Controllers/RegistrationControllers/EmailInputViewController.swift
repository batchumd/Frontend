//
//  EmailInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/3/22.
//

import UIKit
import FirebaseAuth

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
    
    let passwordInput: ATCTextField = {
        let textField = ATCTextField()
        textField.setLeftPadding(20)
        textField.font = UIFont(name: "Brown-bold", size: 16)
        textField.textColor = UIColor(named: "mainColor")
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = try! User()
        self.mainStackView.insertArrangedSubview(emailInput, at: 2)
        self.mainStackView.insertArrangedSubview(passwordInput, at: 3)
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
        
        guard var email = emailInput.text, let password = passwordInput.text else {
            return
        }
        email = email + "@terpmail.umd.edu"
        
        if ValidityChecker().isEmailValid(email) {
            if ValidityChecker().isPasswordValid(password) {
                self.continueButton.disable()
                Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.user?.email = email
                    self.user?.gamesWon = 0
                    self.user?.roundsPlayed = 0
                    self.user?.points = 0
                    self.continueButton.enable()
                    self.showNextViewController(NameInputViewController())
                })
            } else {
                self.displayError(message: "Password must be atleast 8 characters.")
            }
        } else {
            self.displayError(message: "Please enter a valid email")
        }
    }
    
}

struct InfoPlistHelper {
    static func getStringValue(forKey: String) -> String {
        guard let value = Bundle.main.infoDictionary?[forKey] as? String else {
            fatalError("No value found for key!")
        }
         return value
    }
}
