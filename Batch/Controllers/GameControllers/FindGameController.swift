//
//  FindGameController.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class FindGameController: UIViewController, UICollectionViewDelegate {
    
    var statusTimer: CustomTimer?
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var statusCountdown: Countdown?
    
    var attemptingToJoin: Bool = false
    
    let firebaseHelpers = DatabaseManager()
    
    private var minimumSpacing: CGFloat = 10

    private var edgeInsetPadding: CGFloat = 20
    
    var gameOptions = [Game]()
        
    //MARK: UI Elements
    let activityView = ActivityPopupView()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "We found some bachelorette's"
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 22)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Make your pick before the game is full."
        label.font = UIFont(name: "Brown-Bold", size: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let gameCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let gameTimerLabel = GameTimerLabel(fontSize: 25, dark: false)
        
    //MARK: UI Lifecycle Methods
    
    init(gameIDs: [String]) {
        super.init(nibName: nil, bundle: nil)
        firebaseHelpers.getGameStartCountdown { countDown in
            self.statusCountdown = countDown
            self.setupTimer()
        }
        self.view.backgroundColor = UIColor(named: "mainColor")
        self.setupActivityView(title: "Loading Bachelorette's")
        self.getGameInfo(gameIDs: gameIDs)
        self.gameCollectionView.register(GameCardCell.self, forCellWithReuseIdentifier: "result")
        self.gameCollectionView.dataSource = self
        self.gameCollectionView.delegate = self
        self.setupLayout()
        self.listenForCloseGames()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewHeightConstraint.constant = self.gameCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupLayout() {
        self.activityView.removeFromSuperview()
        collectionViewHeightConstraint = self.gameCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
        let gameTimerView = UIView()
        gameTimerView.addSubview(gameTimerLabel)
        gameTimerLabel.centerInsideSuperView()
        let stackView = UIStackView(arrangedSubviews: [informationLabel, tipLabel, gameCollectionView, UIView(), gameTimerView, UIView()])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    }
    
    fileprivate func setupActivityView(title: String) {
        self.view.subviews.forEach { view in
            view.removeFromSuperview()
        }
        activityView.title = title
        self.view.addSubview(activityView)
        activityView.centerInsideSuperView()
        activityView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        activityView.heightAnchor.constraint(equalTo: activityView.widthAnchor).isActive = true
    }
    
    //MARK: Business Logic
    
    fileprivate func getGameInfo(gameIDs: [String]) {
        for i in 0 ..< gameIDs.count {
            let gameID = gameIDs[i]
            self.firebaseHelpers.fetchGameInfo(gameID, listen: true) { gameInfo in
                guard var gameInfo = gameInfo else { return }
                if let x = self.gameOptions.firstIndex(where: {$0.gameID == gameInfo.gameID}) {
                    // We must copy the host data to the updated data
                    gameInfo.host = self.gameOptions[x].host
                    self.gameOptions[x] = gameInfo
                    let indexPath = IndexPath(item: x, section: 0)
                    self.gameCollectionView.reloadItems(at: [indexPath])
                } else {
                    self.firebaseHelpers.fetchUserData(gameInfo.hostID, listen: false) { userData in
                        guard let userData = userData else { return }
                        gameInfo.host = userData
                        self.gameOptions.append(gameInfo)
                        let indexPath = IndexPath(item: i, section: 0)
                        self.gameCollectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }
    }
    
    func setupTimer() {
        self.statusTimer = CustomTimer(handler: { elapsed in
            self.updateTime(elapsed)
        })
    }
    
    @objc func updateTime(_ elapsed: TimeInterval) {
        if statusCountdown != nil {
            if (statusCountdown!.isFinished) {
                self.statusTimer?.stop()
                self.gameTimerLabel.text = "0s"
            } else {
                self.statusCountdown!.currentDate = self.statusCountdown!.currentDate + elapsed
                self.gameTimerLabel.text = self.statusCountdown!.timeRemaining + "s"
            }
        }
    }
    
    fileprivate func listenForCloseGames() {
        firebaseHelpers.listenGamesOngoingStatus(complete: { gamesOngoing in
            if gamesOngoing && !self.attemptingToJoin {
                LocalStorage.shared.userInQueue = false
                self.dismiss(animated: true)
            }
        })
    }
    
}

extension FindGameController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "result", for: indexPath as IndexPath) as! GameCardCell
        cell.game = gameOptions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GameCardCell
        self.setupActivityView(title: "Joining")
        self.attemptingToJoin = true
        guard let game = cell.game else { return }
        NetworkManager().addUserToGame(gameID: game.gameID) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.statusTimer?.startApp()
                    self.setupLayout()
                    self.attemptingToJoin = false
                }
                return
            }
            DispatchQueue.main.async {
                self.statusCountdown = nil
                guard let nav = self.navigationController as? GamesNavigationController else {
                    self.present(GameViewController(gameID: game.gameID), animated: true)
                    return
                } // can comment later
                nav.pushToGameController(game.gameID)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - (minimumSpacing + (edgeInsetPadding * 2))) / 2
        return CGSize(width: width, height: width * 1.55)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return minimumSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return minimumSpacing
        }
}
