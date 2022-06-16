//
//  DateOfBirthInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/8/22.
//

import Foundation
import UIKit

class DateOfBirthInputViewController: RegistrationViewController {
    
    //MARK: UI Elements
    lazy var birthdayInput: ATCTextField = {
        let textField = ATCTextField()
        textField.setLeftPadding(20)
        textField.font = UIFont(name: "Brown-bold", size: 20)
        textField.textColor = UIColor(named: "mainColor")
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.inputView = datePicker
        return textField
    }()
    
    fileprivate let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        return datePicker
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        self.mainStackView.insertArrangedSubview(birthdayInput, at: 2)
        titleLabel.text = "Enter your Birthday."
        subtitleLabel.text = "This allows us to keep your age accurate."
        informationLabel.text = "We never share your birthdate, just your age."
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        setupView()
        self.setupGradient()
        self.animateGradient()
    }
    
    //MARK: Business Logic
    @objc func continueButtonTapped() {
        
        if ValidityChecker().isBirthdateValid(self.datePicker.date) {
            showPhotosInputController()
        } else {
            displayError(message: "You must be 18 to use Batch")
        }
        
    }
    
    @objc func showPhotosInputController() {
        let vc = PhotosInputViewController()
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func datePickerChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.birthdayInput.text = dateFormatter.string(from: self.datePicker.date)
    }
}
