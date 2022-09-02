//
//  GameViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation
import UIKit
import FirebaseFirestore

class GameViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- Variables

    fileprivate var messagesFetchingStatus: FetchingState = .notFetched
    fileprivate var playersFetchingStatus: FetchingState = .notFetched
    
    fileprivate var keyboardIsShowing: Bool = false
    fileprivate var keyboardHeight: CGFloat = 0
    
    fileprivate var gameID: String
        
    var questionsAsked: [String] = []
    
    var statusTimer: CustomTimer?
    
    var statusCountdown: Countdown? {
        didSet {
            guard let statusCountdown = statusCountdown else { return }
            self.setupTimer()
        }
    }
                            
    fileprivate let bottomSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
                
    var game: Game? {
        didSet {
            guard let game = self.game else { return }
                        
            if (game.playerIDs.count == game.players?.count) {
                self.playersFetchingStatus = .fetched
            }
            
            if self.playersFetchingStatus == .notFetched {
                self.fetchPlayersData()
            }
            
            if game.host == nil {
                self.fetchHostData()
            }
            
            if self.messagesFetchingStatus == .notFetched && (game.playerIDs.count == game.players?.count || game.players == nil) && game.host != nil  {
                self.fetchResponses()
                self.messagesFetchingStatus = .fetched
            }
            
            if game.isHost && game.status == .waiting && game.timer == nil {
                DatabaseManager.shared.getGameStartCountdown { countDown in
                    guard let countDown = countDown else { return }
                    DatabaseManager.shared.setGameCountdown(gameID: game.gameID, countdown: countDown, complete: {})
                }
            }
            
            self.hostNameTitle.text =  "\(game.host?.name ?? ""), \(game.host?.age ?? 0)"
            self.statusCountdown = game.timer
            self.headerView.game = game
            self.handleGameState()
        }
    }
                
    //MARK:- Elements
    
    let hostNameTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
    
    let contentView = UIView()
    
    let questionsView = QuestionsView()
    
    let chatView = ChatView()
        
    let headerView = GameHeaderView()
        
    //MARK:- Controller Setup
    init(gameID: String) {
        self.gameID = gameID
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocalStorage.shared.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchQuestions()
        
        DatabaseManager.shared.fetchGameInfo(self.gameID, listen: true) { (gameInfo) in
            
            guard var gameInfo = gameInfo else { return }
            
            if let game = self.game {
                if gameInfo.playerIDs != game.playerIDs {
                    self.playersFetchingStatus = .notFetched
                }
                gameInfo.players = game.players
                gameInfo.host = game.host
            }
            
            self.game = gameInfo
                                    
        }
        
        self.questionsView.selectionDelegate = self
        self.headerView.membersCollection.selectionDelegate = self
        self.chatView.responsesView.selectionDelegate = self
        handleKeyboardLogic()
        setupMainView()
        setupHostNameTitle()
    }
    
    fileprivate func setupHostNameTitle() {
        hostNameTitle.textAlignment = .center
        hostNameTitle.font = UIFont(name: "Gilroy-Extrabold", size: 18)
        hostNameTitle.textColor = UIColor(named: "customGray")
        self.navigationItem.titleView = hostNameTitle
    }
    
    fileprivate func setupLeaveButton() {
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 75, height: 30)))
        let btnBack = UIButton(frame: CGRect(x:0, y: 0, width: 30, height: 30))
        btnBack.setImage(UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnBack.tintColor = UIColor(red: 255/255, green: 90/255, blue: 82/255, alpha: 1.0)
        btnBack.isUserInteractionEnabled = false
        let backLabel = UILabel(frame: CGRect(x: 30, y: 1, width: 60, height: 30))
        backLabel.text = "Leave"
        backLabel.font = UIFont(name: "Brown-bold", size: 16)
        backLabel.textColor = UIColor(red: 255/255, green: 90/255, blue: 82/255, alpha: 1.0)
        containerView.addSubview(btnBack)
        containerView.addSubview(backLabel)
        let tapBackContainer = UITapGestureRecognizer(target: self, action: #selector(self.leaveAction))
        containerView.addGestureRecognizer(tapBackContainer)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containerView)
    }
    
    @objc func leaveAction() {
        let alert = UIAlertController(title: "Are you sure?", message: "You won't be able to re-enter.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Stay", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave", style: UIAlertAction.Style.destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setupMainView() {
        
        view.addSubview(headerView)
        view.backgroundColor = .white
        
        headerView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
        headerView.heightAnchor.constraint(equalToConstant: 165).isActive = true

        view.addSubview(contentView)
        contentView.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!).withAlphaComponent(0.65)
        contentView.clipsToBounds = true
        contentView.anchor(top: self.headerView.bottomAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)

        contentView.addSubview(questionsView)
        questionsView.centerInsideSuperView()
        questionsView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(chatView)
        chatView.fillSuperView()

        setupEndEditingGesture()
        setupCreateMessageView()
        
        self.view.bringSubviewToFront(headerView)
    }
    
    @objc func appEnteredForeground() {
        if self.keyboardIsShowing {
            chatView.frame.origin.y -= keyboardHeight - bottomSafeArea
        }
    }
    
    fileprivate func setupCreateMessageView() {
        chatView.createMessage.messageField.delegate = self
        chatView.createMessage.sendButton.addTarget(self, action: #selector(self.addMessage), for: .touchUpInside)
        chatView.createMessage.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Logic
    @objc func addMessage() {
        guard let game = game else { return }
        if let messageText = chatView.createMessage.messageField.text {
            DatabaseManager.shared.addResponse(gameID: game.gameID, content: messageText) {
                self.chatView.createMessage.messageField.text = ""
                self.chatView.createMessage.sendButton.isHidden = true
            }
        }
    }
    
    fileprivate func fetchQuestions() {
        DatabaseManager.shared.fetchQuestions(complete: { questions in
            let questionsThatCanBeAsked = Set(questions).subtracting(self.questionsAsked)
            self.questionsView.questions = Array(questionsThatCanBeAsked).prefix(4).map{String($0)}
        })
    }
    
    func handleGameState() {
        
        guard let game = self.game else { return }
        
        if game.status == .waiting {
            if game.isHost {
                self.questionsView.isHidden = false
                self.chatView.isHidden = true
            }
        }
        
        if game.status == .chat {
            self.questionsView.isHidden = true
            self.chatView.isHidden = false
        }
        
        if game.status == .eliminate {
            if game.isHost {
                self.questionsView.isHidden = true
                self.chatView.isHidden = true
    //            self.eliminationView.isHidden = false
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Gesture recognizers
extension GameViewController: UIGestureRecognizerDelegate {
    func setupEndEditingGesture() {
        let endEditingGesture = UISwipeGestureRecognizer(target: self, action: #selector(textFieldShouldReturn(_:)))
        endEditingGesture.direction = .up
        self.chatView.responsesView.addGestureRecognizer(endEditingGesture)
        endEditingGesture.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: Fetching data
extension GameViewController {
    
    func fetchHostData() {
        guard let game = self.game else { return }
        DatabaseManager.shared.fetchUserData(game.hostID, listen: false) { userData in
            guard var userDataMutable = userData else { return }
            userDataMutable.isHost = true
            self.game!.host = userDataMutable
        }
    }
    
    func fetchPlayersData() {
        
        self.playersFetchingStatus = .fetching
        
        guard let game = self.game else { return }
        
        var players = game.players ?? [:]
        
        guard let uid = DatabaseManager.shared.getUserID() else { return }
                
        for i in 0 ..< game.playerIDs.count {
                        
            let playerID = game.playerIDs[i]
            
            if players[playerID] == nil {
                if playerID == uid {
                    guard var currentUser = LocalStorage.shared.currentUserData else { return }
                    currentUser.isHost = false
                    players[playerID] = currentUser
                    self.game!.players = players
                } else {
                    DatabaseManager.shared.fetchUserData(playerID, listen: false) { userData in
                        guard var userData = userData else {
                            players[playerID] = nil
                            self.game!.players = players
                            return
                        }
                        userData.isHost = false
                        players[playerID] = userData
                        self.game!.players = players
                    }
                }
            }
            
        }
    }
    
    func fetchResponses() {
        guard let game = self.game else { return }
        let query = Firestore.firestore().collection("games").document(game.gameID).collection("responses").limit(to: 25).order(by: "created_at", descending: false)
        query.addSnapshotListener(includeMetadataChanges: true) { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            self.chatView.responsesView.responses.removeAll()
            var temp_stack = [Message]()
            for doc in querySnapshot!.documents {
                do {
                    var response = try Message.init(from: doc.data())
                    if let sender = game.players?[response.sender_id] {
                        response.sender = sender
                    } else if response.sender_id == game.hostID {
                        response.sender = game.host
                    } else {
                        response.sender = nil
                    }
                    temp_stack.insert(response, at: 0)
                }
                catch {
                    print("couldnt get message")
                }
            }
            
            self.chatView.responsesView.responses.insert(contentsOf: temp_stack, at: 0)
            self.chatView.responsesView.reloadData()

        }
    }
    
}

extension GameViewController: UserSelectionDelegate {
    func userSelected(user: User) {
        let vc = ProfileViewController(user: user)
        self.present(vc, animated: true)
    }
}


// MARK: Handle the countdown logic for header
extension GameViewController {
    
    func setupTimer() {
        self.statusTimer?.timer.invalidate()
        self.statusTimer = CustomTimer(handler: { elapsed in
            self.updateTime(elapsed)
        })
    }
    
    func updateTime(_ elapsed: TimeInterval) {
        if self.statusCountdown != nil {
            if (statusCountdown!.isFinished) {
                self.statusTimer?.stop()
                chatView.createMessage.gamerTimerLabel.text = "0s"
            } else {
                self.statusCountdown!.currentDate = self.statusCountdown!.currentDate + elapsed
                chatView.createMessage.gamerTimerLabel.text = self.statusCountdown!.timeRemaining + "s"
            }
        }
    }
    
}

extension GameViewController: QuestionSelectionDelegate {
    func questionSelected(question: String) {
        //make sure ishost
        guard let game = self.game else { return }
        DatabaseManager.shared.setQuestionForGame(gameID: game.gameID, question: question) {
            self.questionsAsked.append(question)
        }
    }
}

extension GameViewController: LocalStorageDelegate {
    func lobbyStateChanged() {
        guard let game = self.game else { return }
        guard let lobbyState = LocalStorage.shared.lobbyState else { return }
        if lobbyState == .live {
            if game.isHost {
                if self.questionsView.questionSelected == false {
                    self.questionsView.selectRandom()
                }
                DatabaseManager.shared.startRoundOne(gameID: game.gameID) { error in
                    if let error = error {
                        //handle error
                        print(error)
                        return
                    }
                }
            }
        }
    }
}

// MARK: Keyboard functions

extension GameViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatView.createMessage.messageField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardIsShowing {
            view.endEditing(true)
            chatView.frame.origin.y = 0
            keyboardIsShowing = false
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !keyboardIsShowing {
                keyboardHeight = keyboardSize.height
                chatView.frame.origin.y -= keyboardHeight - bottomSafeArea
                keyboardIsShowing = true
            }
        }
    }
    
    fileprivate func handleKeyboardLogic() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.keyboardWillHide))
        gesture.direction = .down
        self.view.addGestureRecognizer(gesture)
        chatView.responsesView.addGestureRecognizer(gesture)
    }
    
}
