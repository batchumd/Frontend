//
//  GenderInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/15/22.
//

import UIKit

class GenderInputViewController: RegistrationViewController {
    
    var selectedGender: Gender?
        
    //MARK: UI Elements
    let genderOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        titleLabel.text = "Select your gender."
        subtitleLabel.text = "How do you identify?"
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
                let button = UIButton(configuration: filled, primaryAction: nil )
                button.layer.opacity = 0.5
                button.addTarget(self, action: #selector(genderSelected), for: .touchUpInside)
                button.tag = index
                self.genderOptionsStackView.addArrangedSubview(button)
            }
        }
        self.mainStackView.insertArrangedSubview(self.genderOptionsStackView, at: 2)
    }
    
    //MARK: Business Logic
    @objc func genderSelected(sender: UIButton) {
        self.genderOptionsStackView.arrangedSubviews.forEach { genderButton in
            genderButton.layer.opacity = 0.5
        }
        UIView.animate(withDuration: 0.20, animations: {
            sender.layer.opacity = 1.0
        })
        switch sender.tag {
            case 0: self.selectedGender = .male
            case 1: self.selectedGender = .female
            case 2: self.selectedGender = .nonbinary
            default: return
        }
    }
    
    @objc func continueButtonTapped() {
        guard let gender = self.selectedGender else {
            self.displayError(message: "Please select a gender option")
            return
        }
        self.user?.gender = gender
        self.showNextViewController(InterestedInInputViewController())
    }
}
