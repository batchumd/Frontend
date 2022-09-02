//
//  ViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit

class HomeController: UIViewController {
    
    var user: User! {
        didSet {
            self.populateProfileBoxWithData()
        }
    }
        
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
    
    let countdownView = CountdownView(isFullscreen: false)
    
    let profileBoxView = ProfileBoxView()
    
    let inviteFriendView = InviteFriendView()
   
    override func viewWillAppear(_ animated: Bool) {
        GlobalCountdown.shared.delegate = self
        self.countdownUpdated()
    }
    
    override func viewDidLoad() {
        setupLayout()
        if LocalStorage.shared.userInQueue == true {
            self.countdownView.actionView.joiningStatus = .fetched
        } else {
            self.countdownView.actionView.joiningStatus = .notFetched
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem.init(title: nil, image: UIImage(named: "HomeIcon"), tag: 1)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    fileprivate func setupLayout() {
        layoutCountdownView()
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin/2).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin).isActive = true
        countdownView.heightAnchor.constraint(equalToConstant: (view.bounds.size.width - (margin * 2)) * 0.45).isActive = true
        inviteFriendView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let showProfileTabGesture = UITapGestureRecognizer(target: self, action: #selector(switchToProfileTab))
        profileBoxView.addGestureRecognizer(showProfileTabGesture)
    }
    
    fileprivate func layoutCountdownView() {
        self.countdownParent.addSubview(countdownView)
        countdownView.fillSuperView()
    }
    
    //MARK: - Business Logic
    
    @objc func switchToProfileTab() {
        self.tabBarController?.selectedIndex = 2
    }
    
    func populateProfileBoxWithData() {
        //Get user data from localstorage singleton
        profileBoxView.nameAgeLabel.text = "\(user.name), \(user.age)"
        profileBoxView.statsStackView.gamesPlayedStatBox.statValue = user.roundsPlayed
        profileBoxView.statsStackView.wonStatBox.statValue = user.gamesWon
        profileBoxView.statsStackView.pointsStatBox.statValue = user.points
        
        //Layout the view so KingFisher can grab its frame
        profileBoxView.layoutIfNeeded()
        if user.profileImages.isEmpty {
            profileBoxView.profileImageView.image = UIImage(named: "defaultProfileUser")
        } else {
            profileBoxView.profileImageView.setCachedImage(urlstring: user.profileImages.first!, size: profileBoxView.profileImageView.frame.size){}
        }
    }
    
    @objc func showGamesNavController() {
        
        guard let lobbyState = LocalStorage.shared.lobbyState else { return }
        
        if lobbyState != .open {
            // Check the user on the backend
            self.countdownView.actionView.joiningStatus = .fetching
            NetworkManager().addUserToQueue { error in
                if let error = error {
                    print(error)
                    self.countdownView.actionView.joiningStatus = .notFetched
                    return
                }
                DispatchQueue.main.async {
                    self.countdownView.actionView.joiningStatus = .fetched
                }
            }
        }
        
        if lobbyState == .waiting {
            let vc = GamesNavigationController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    
    }
}

extension HomeController: CountdownDelegate {
    
    func statusChanged(isFinished: Bool) {
        if isFinished {
            self.countdownView.counter.text = "0s"
        }
    }
    
    func countdownUpdated() {
        self.countdownView.timeRemaining = GlobalCountdown.shared.countdown?.timeRemaining
    }
    
}

extension Date {
    func atSpecifcHour(hour: Int) -> Date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour)) ?? Date()
    }
}
