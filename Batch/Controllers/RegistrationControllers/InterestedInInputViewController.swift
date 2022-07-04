//
//  InterestedInInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation
import UIKit

class InterestedInInputViewController: RegistrationViewController {
    
    var interestedIn: [Gender] = []
    
    let firebaseHelpers = FirebaseHelpers()
        
    //MARK: UI Elements
    let interestedInOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        titleLabel.text = "Who are you interested in?"
        subtitleLabel.text = "These are the people that you'll play for."
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        setupView()
        self.setupGradient()
        self.animateGradient()
        self.setupGenderOptions()
    }
    
    func setupGenderOptions() {
        for (index, gender) in Gender.allCases.enumerated() {
            if #available(iOS 15.0, *) {
                var filled = UIButton.Configuration.filled()
                filled.buttonSize = .large
                filled.cornerStyle = .large
                filled.baseBackgroundColor = .white
                filled.attributedTitle = AttributedString(NSAttributedString(string: gender.rawValue.capitalizingFirstLetter(), attributes: [
                        .font: UIFont(name: "Gilroy-ExtraBold", size: 20)!,
                        .foregroundColor: UIColor(named: "mainColor")!]))
                let button = UIButton(configuration: filled, primaryAction: nil)
                button.layer.opacity = 0.5
                button.addTarget(self, action: #selector(genderSelected), for: .touchUpInside)
                button.tag = index
                self.interestedInOptionsStackView.addArrangedSubview(button)
            }
        }
        self.mainStackView.insertArrangedSubview(self.interestedInOptionsStackView, at: 2)
    }
    
    //MARK: Business Logic
    @objc func genderSelected(sender: UIButton) {
        guard let gender = getGenderFromIndex(sender.tag) else {
            return
        }
        if self.interestedIn.contains(gender) {
            UIView.animate(withDuration: 0.20, animations: {
                sender.layer.opacity = 0.5
            })
            self.interestedIn.removeAll(where: {$0 == gender})
        } else {
            UIView.animate(withDuration: 0.20, animations: {
                sender.layer.opacity = 1.0
            })
            self.interestedIn.append(gender)
        }
    }
    
    fileprivate func getGenderFromIndex(_ index: Int) -> Gender? {
        switch index {
            case 0: return .male
            case 1: return .female
            case 2: return .nonbinary
            default: return nil
        }
    }
    
    @objc func continueButtonTapped() {
        if self.interestedIn.count == 0 {
            self.displayError(message: "You must select at least one option")
        } else {
            self.user?.interestedIn = self.interestedIn
            firebaseHelpers.addNewUserToDatabase(userData: self.user!) {
                Switcher.updateRootVC()
            }
        }
    }
    
}
