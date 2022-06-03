//
//  SignedOutViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/1/22.
//

import UIKit

class SignedOutViewController: ViewControllerWithGradient {
    
    let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "BatchLogo")?.withTintColor(.white)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let layer = CALayer()
    
    let schoolLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "umd"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var infoBox: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = .white
        self.layer.contents = UIImage(named: "celebration pattern")?.cgImage
        self.layer.contentsGravity = .resizeAspect
        view.layer.insertSublayer(self.layer, at: 0)
        return view
    }()
    
    lazy var infoStack: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [self.infoLabel, self.schoolLogo])
        stackview.spacing = 20
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        return stackview
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 20)
        label.text = "WE’VE LAUNCHED AT"
        label.textAlignment = .center
        label.textColor = UIColor(named: "mainColor")!
        return label
    }()
    
    let madeWithLoveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Brown-Bold", size: 14)
        label.text = "Made with ♥ in College Park, MD"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var registerButton: UIButton = {
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.buttonSize = .large
            filled.cornerStyle = .large
            filled.baseBackgroundColor = .white
            filled.attributedTitle = AttributedString(NSAttributedString(string: "Register", attributes: [
                    .font: UIFont(name: "Gilroy-ExtraBold", size: 20)!,
                    .foregroundColor: UIColor(named: "mainColor")!]))
            let button = UIButton(configuration: filled, primaryAction: nil )
            return button
        } else {
            return UIButton()
        }
    }()
    
    var signInButton: UIButton = {
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.buttonSize = .large
            filled.cornerStyle = .large
            filled.baseBackgroundColor = .white.withAlphaComponent(0.4)
            filled.attributedTitle = AttributedString(NSAttributedString(string: "Sign In", attributes: [
                    .font: UIFont(name: "Gilroy-ExtraBold", size: 20)!,
                    .foregroundColor: UIColor.white]))
            let button = UIButton(configuration: filled, primaryAction: nil)
            return button
        } else {
            return UIButton()
        }
    }()
    
    let termsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: "By signing in or creating an account you agree to our Terms of Service and Privacy Policy.")

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Brown-bold", size: 14)!, range:NSMakeRange(0, attributedString.length))

        // *** Set Attributed String to your label ***
        label.attributedText = attributedString
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.logoView, self.infoBox, self.termsLabel, self.buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.registerButton, self.signInButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mainStackView.layoutIfNeeded()
        self.layer.frame = self.infoBox.bounds
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoBox.addSubview(infoStack)
        self.infoStack.leadingAnchor.constraint(equalTo: self.infoBox.leadingAnchor).isActive = true
        self.infoStack.trailingAnchor.constraint(equalTo: self.infoBox.trailingAnchor).isActive = true
        self.infoStack.centerYAnchor.constraint(equalTo: self.infoBox.centerYAnchor).isActive = true
        
        self.view.addSubview(self.mainStackView)
        self.schoolLogo.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.logoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        self.mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        self.mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.infoBox.heightAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        
        self.view.addSubview(self.madeWithLoveLabel)
        self.madeWithLoveLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        self.madeWithLoveLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        signInButton.addTarget(self, action: #selector(showSignInController), for: .touchUpInside)
        
    }
    
    @objc func showSignInController() {
        let vc = EmailInputViewController()
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    
}
