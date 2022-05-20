//
//  ViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit

class HomeController: UIViewController {
    
    let margin: CGFloat = 36
    
    let mainView = UIView()
    
//    let header: UILabel = {
//        let label = UILabel()
//        let attributedString = NSMutableAttributedString(string: "Join a game and play!\nLast one remaining wins.")
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
//        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "mainColor") ?? UIColor.purple, range: NSRange(location:21,length:25))
//        label.attributedText = attributedString
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "Gilroy-ExtraBold", size: 22)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        return label
//    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countdownView, profileBoxView, referallInfoView])
        stackView.axis = .vertical
        stackView.subviews.forEach { view in
            stackView.setCustomSpacing(30, after: view)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let countdownView = CountdownView()
    
    let profileBoxView = ProfileBoxView()
    
    let referallInfoView: UIView = {
        let view = UIView()
        view.addShadow()
        let label = UILabel()
        label.text = "Invite your friends!"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin/2).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin).isActive = true
        countdownView.heightAnchor.constraint(equalToConstant: (view.bounds.size.width - (margin * 2)) * 0.5).isActive = true
        referallInfoView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    //MARK: - Business Logic
    
    @objc fileprivate func showFindGameController() {
        let vc = FindGameController()
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

