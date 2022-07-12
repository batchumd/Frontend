//
//  EmailInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EmailInputViewController: RegistrationViewController {
    
    var authType: AuthType
        
    let auth = Auth.auth()
        
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

    init(type: AuthType) {
        self.authType = type
        super.init(nibName: nil, bundle: nil)
        self.user = try! User()
        self.mainStackView.insertArrangedSubview(emailInput, at: 2)
        self.mainStackView.insertArrangedSubview(passwordInput, at: 3)
        switch type {
            case .reAuth:
                titleLabel.text = "Please confirm your login to delete your account."
                subtitleLabel.isHidden = true
            case .register: titleLabel.text = "Enter your UMD \nstudent email."
            case .signIn: titleLabel.text = "Sign in to your account."
        }
        subtitleLabel.text = "Batch is currently only available for the University of Maryland community. We plan to launch in more places in the near future!"
        informationLabel.text = "We will never share your email with anyone or display it on your profile."
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
        setupView()
        self.setupGradient()
        self.animateGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Business Logic
    
    @objc func continueButtonClicked() {
        
        guard var email = emailInput.text, let password = passwordInput.text else { return }
        
        email = email + "@terpmail.umd.edu"
                
        switch self.authType {
            case .register: handleRegistration(email: email, password: password)
            case .signIn: handleSignin(email: email, password: password)
            case .reAuth: handleSignin(email: email, password: password)
        }
    }
    
    fileprivate func handleRegistration(email: String, password: String) {
        
        let validityChecker = ValidityChecker()
        
        // Check if email is valid
        if validityChecker.isEmailValid(email) {
            
            // Check if password throws off error
            if let error = validityChecker.passwordErrorCheck(password) {
                self.displayError(message: error.localizedDescription)
                return
            }
            
            self.continueButton.disable()
            auth.createUser(withEmail: email, password: password, completion: { (result, error) in
                if let error = error {
                    let errorCode = AuthErrorCode(_nsError: error as NSError)
                    switch errorCode.code {
                        case .emailAlreadyInUse:
                            self.displayError(message: "Email already in use.")
                        case .invalidEmail:
                            self.displayError(message: "Email is invalid")
                        default: break
                    }
                } else {
                    self.user?.email = email
                    self.user?.gamesWon = 0
                    self.user?.roundsPlayed = 0
                    self.user?.points = 0
                    self.continueButton.enable()
                    self.showNextViewController(NameInputViewController())
                }
                self.continueButton.enable()
            })
        }
    }
    
    fileprivate func handleSignin(email: String, password: String) {
        self.continueButton.disable()
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                switch errorCode.code {
                    case .wrongPassword:
                        self.displayError(message: "Password was incorrect.")
                    case .userNotFound:
                        self.displayError(message: "Email does not exist.")
                    default: break
                }
                self.continueButton.enable()
                return
            }
            self.continueButton.enable()
            if self.authType == .reAuth {
                self.navigationController!.popViewController(animated: true)
            } else if self.authType == .signIn {
                Switcher.shared.updateRootVC()
            }
        }
    }
}

enum AuthType {
    case signIn
    case reAuth
    case register
}
