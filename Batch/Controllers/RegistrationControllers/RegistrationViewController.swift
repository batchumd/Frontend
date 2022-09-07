//
//  RegistrationViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/4/22.
//


import UIKit

class RegistrationViewController: UIViewController {
    
    //MARK: Variables
    
    var user: [String: Any]?
    
    var bottomConstraint: NSLayoutConstraint?
    
    //MARK: UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Brown-bold", size: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var errorView: UIStackView = {
        let imageView = UIImageView(image: UIImage(systemName: "info.circle.fill"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        let stackView = UIStackView(arrangedSubviews: [imageView, self.errorLabel])
        stackView.backgroundColor = UIColor(red: 255/255, green: 65/255, blue: 65/255, alpha: 0.6)
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isHidden = true
        stackView.axis = .horizontal
        stackView.spacing = 10
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        stackView.addArrangedSubview(spacer)
        return stackView
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Brown-bold", size: 14)
        label.text = "error"
        label.textColor = .white
        return label
    }()
    
    var continueButton = ContinueButton()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
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
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, errorView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical
        return stackView
    }()
    
    let contentView = UIView()
    
    func setupView() {
        setupContentView()
        setupMainStackView()
        setupBottomStack()
                
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupBackButton()
    }
    
    fileprivate func setupContentView() {
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomConstraint?.isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    fileprivate func setupMainStackView() {
        self.contentView.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 35).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -35).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        errorView.leadingAnchor.constraint(equalTo: self.mainStackView.leadingAnchor).isActive = true
        errorView.trailingAnchor.constraint(greaterThanOrEqualTo: self.mainStackView.trailingAnchor).isActive = true
    }
    
    fileprivate func setupBottomStack() {
        self.view.addSubview(bottomStack)
        self.bottomStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: UIApplication.shared.delegate?.window??.safeAreaInsets.top != nil ? 0 : -20).isActive = true
        self.bottomStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -35).isActive = true
        self.bottomStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 35).isActive = true
        self.continueButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.continueButton.heightAnchor.constraint(equalTo: self.continueButton.widthAnchor).isActive = true
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {

        if let userInfo = notification.userInfo {

            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue

            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification

            self.bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    fileprivate func setupBackButton() {
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 50)))
        let btnBack = UIButton(frame: CGRect(x:0, y: 0, width: 45, height: 45))
        btnBack.transform = CGAffineTransform(scaleX: -1, y: 1)
        btnBack.setImage(UIImage(named: "continue")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnBack.tintColor = .white
        btnBack.isUserInteractionEnabled = false
        let backLabel = UILabel(frame: CGRect(x: 40, y: 0, width: 60, height: 45))
        backLabel.text = "Back"
        backLabel.font = UIFont(name: "Brown-bold", size: 20)
        backLabel.textColor = .white
        containerView.addSubview(btnBack)
        containerView.addSubview(backLabel)
        let tapBackContainer = UITapGestureRecognizer(target: self, action: #selector(self.backAction))
        containerView.addGestureRecognizer(tapBackContainer)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containerView)
    }
    
    func displayError(message: String) {
        self.errorLabel.text = message
        UIView.animate(withDuration: 0.20, animations: {
            self.errorView.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    func showNextViewController(_ controller: RegistrationViewController) {
        controller.user = self.user
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(controller, animated: false)
//        self.user!.saveToDefaults(forKey: "RegistrationData") {
//            controller.user = self.user
//            let transition:CATransition = CATransition()
//            transition.duration = 0.25
//            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//            transition.type = CATransitionType.fade
//            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//            self.navigationController?.pushViewController(controller, animated: false)
//        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
