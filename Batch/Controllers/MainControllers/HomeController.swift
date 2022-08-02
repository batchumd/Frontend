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
    
    let countdownView = CountdownView(isFullscreen: false)
    
    let profileBoxView = ProfileBoxView()
    
    let inviteFriendView = InviteFriendView()
    
    override func viewDidAppear(_ animated: Bool) {
        LocalStorage.shared.delegate = self
        userDataChanged()
        lobbyOpenChanged()
    }
    
    override func viewDidLoad() {
        setupLayout()
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
        countdownView.heightAnchor.constraint(equalToConstant: (view.bounds.size.width - (margin * 2)) * 0.5).isActive = true
        inviteFriendView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let showProfileTabGesture = UITapGestureRecognizer(target: self, action: #selector(switchToProfileTab))
        profileBoxView.addGestureRecognizer(showProfileTabGesture)
        self.addShadowForCountdownParent()
    }
    
    fileprivate func layoutCountdownView() {
        self.countdownParent.addSubview(countdownView)
        countdownView.fillSuperView()
        let tapShowCountdown = UITapGestureRecognizer(target: self, action: #selector(self.showCountdownViewController))
        countdownParent.addGestureRecognizer(tapShowCountdown)
    }
    
    func addShadowForCountdownParent() {
        self.countdownParent.addShadow(radius: 20, offset: CGSize(width: 0, height: 0), opacity: 0.0, color: UIColor(named: "mainColor")!)
    }
    
    //MARK: - Business Logic
    
    @objc func switchToProfileTab() {
        self.tabBarController?.selectedIndex = 3
    }
    
    fileprivate func populateProfileBoxWithData(user: User) {
        
        //Get user data from localstorage singleton
        
        profileBoxView.nameAgeLabel.text = "\(user.name), \(user.age)"
        profileBoxView.statsStackView.roundsStatBox.statValue = user.roundsPlayed
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
    
    @objc fileprivate func showCountdownViewController() {
        guard let lobbyOpen = LocalStorage.shared.lobbyOpen else { return }
        let vc = GamesNavigationController()
        if !lobbyOpen {
            vc.countdownVC.countdownView.setupCountDown(currentDate: self.countdownView.countdown.currentDate, nextGame: self.countdownView.countdown.targetDate)
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

extension HomeController: LocalStorageDelegate {
    func userDataChanged() {
        guard let user = LocalStorage.shared.currentUserData else {
            print("failed to get user data")
            return
        }
        populateProfileBoxWithData(user: user)
        let navController = self.navigationController as! CustomNavController
        navController.pointsLabel.text = String(user.points)
    }
    
    func lobbyOpenChanged() {
        // Grab lobby variable from localstorage
        
        guard let lobbyOpen = LocalStorage.shared.lobbyOpen else { return }
        
        // Set the shadow opacity if the loby is open
        self.countdownParent.layer.shadowOpacity = lobbyOpen ? 1.0 : 0.0
        
        if lobbyOpen {
            self.countdownView.countdownTimer?.stop()
            self.countdownView.setViewForLobbyOpen()
        } else {
            self.countdownView.setViewForLobbyClosed()
            if countdownView.countdownTimer == nil {
                handleCountdownToNextLobbyOpen()
            } else {
                self.countdownView.countdownTimer?.startApp()
            }
        }
    }
    
    func handleCountdownToNextLobbyOpen() {
        NetworkManager().getCurrentTime { date, error in
            guard let date = date else { return }
            LocalStorage.shared.serverDate = date
            FirebaseHelpers().getNextGameTime { nextDate in
                DispatchQueue.main.async {
                    self.countdownView.setupCountDown(currentDate: date, nextGame: nextDate)
                }
            }
        }
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
