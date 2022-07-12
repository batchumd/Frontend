//
//  ViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit

class HomeController: UIViewController {
    
    let margin: CGFloat = 30
    
    let mainView = UIView()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countdownParent, profileBoxView, inviteFriendView])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let countdownParent: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        return view
    }()
    
    let countdownView = CountdownView()
    
    let profileBoxView = ProfileBoxView()
    
    let inviteFriendView = InviteFriendView()
    
    override func viewDidLoad() {
        self.countdownParent.addSubview(countdownView)
        countdownView.fillSuperView()
        let tapShowCountdown = UITapGestureRecognizer(target: self, action: #selector(self.showCountdownViewController))
        countdownParent.addGestureRecognizer(tapShowCountdown)
        profileBoxView.settingsButton.addTarget(self, action: #selector(showPreferences), for: .touchUpInside)
        setupLayout()
        NetworkManager().getCurrentTime { date, error in
            if let error = error {
                print(error)
                return
            }
            self.countdownView.countdown = GameCountdown(currentDate: date!)
            self.countdownView.countdown.countdownDelegate = self
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "HomeIcon"), tag: 1)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Gilroy-ExtraBold", size: 11)!], for: .normal)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin/2).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin).isActive = true
        countdownView.heightAnchor.constraint(equalToConstant: (view.bounds.size.width - (margin * 2)) * 0.5).isActive = true
        inviteFriendView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    //MARK: - Business Logic
    
    func addShadowForCountdownParent() {
        self.countdownParent.addShadow(radius: 20, offset: CGSize(width: 0, height: 0), opacity: 1.0, color: UIColor(named: "mainColor")!)
    }
    
//    @objc fileprivate func showFindGameController() {
//        let vc = FindGameController()
//        let transition:CATransition = CATransition()
//        transition.duration = 0.25
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.fade
//        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//        self.navigationController?.pushViewController(vc, animated: false)
//    }
    
    @objc func showPreferences() {
        let vc = UINavigationController(rootViewController: PreferencesViewController())
        self.present(vc, animated: true)
    }
    
    @objc fileprivate func showCountdownViewController() {
        let vc = CountdownViewController(self.countdownView.countdown)
        let transition:CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}


extension HomeController: CountdownDelegate {
    func isFinished(_ value: Bool) {
        if value {
            self.addShadowForCountdownParent()
        }
    }
}
