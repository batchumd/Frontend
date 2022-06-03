//
//  EmailInputViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/3/22.
//

import Foundation
import UIKit

class EmailInputViewController: ViewControllerWithGradient {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 30)
        label.text = "Enter your UMD \nstudent email."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Brown-bold", size: 14)
        label.text = "Batch is currently only available for the University of Maryland community. We plan to launch in more places in the near future!"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
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
    
    var continueButton: UIButton = {
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.buttonSize = .large
            filled.imagePlacement = .all
            filled.imagePadding = 5
            filled.baseBackgroundColor = UIColor.white
            filled.image = UIImage(named: "continue")!.withTintColor(UIColor(named: "mainColor")!)
            let button = UIButton(configuration: filled, primaryAction: nil)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        } else {
            return UIButton()
        }
    }()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "We will never share your email with anyone or display it on your profile."
        label.textColor = .white
        label.font = UIFont(name: "Brown-bold", size: 14)
        return label
    }()
    
    lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [informationLabel, continueButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, emailInput])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 35).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -35).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        view.addSubview(bottomStack)
        bottomStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -35).isActive = true
        bottomStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 35).isActive = true
        self.continueButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.continueButton.heightAnchor.constraint(equalTo: self.continueButton.widthAnchor).isActive = true
    }
    
}

class ATCTextField: UITextField {
    let padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rightpadding = self.rightView?.bounds.width ?? 0
        return bounds.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: rightpadding))
    }
}

extension UITextField {
    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
