//
//  GameViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation
import UIKit

struct Game {
    var chatID: String
    var players: [User]
    var host: User
}

class GameViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- Variables
    fileprivate var chatID: String
        
    fileprivate var hasFetchedMessages: Bool!
    
    fileprivate var hasAddedMembers: Bool!
    
    fileprivate var messages = [Message(sender: User(name: "Tom", age: 23, image: UIImage(named: "nicole")!, points: 233), content: "Hey whats up!", time: Date(timeIntervalSinceNow: 2333), type: .text)]
        
    var gameData: Game! {
        didSet {
            self.headerView.players = (gameData.players, gameData.host)
        }
    }
    
    fileprivate let messageId = "message"
    
    fileprivate let infoId = "info"
    
    fileprivate var chatViewOffset: CGFloat = 0
    
    //MARK:- Elements
    lazy var mainView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chatView, createMessage])
        stackView.axis = .vertical
        return stackView
    }()
    
    let chatView = ChatView()
    
    let headerView = GameTitleView()
        
    let createMessage = CreateMessageView()
    
    //MARK:- Controller Setup
    init(chatID: String) {
        self.chatID = chatID
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasAddedMembers = false
        hasFetchedMessages = false
        handleKeyboardLogic()
        setupMainView()
        setupLeaveButton()
        setupPointsLabel()
    }
    
    fileprivate func setupLeaveButton() {
        let pointsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        pointsLabel.text =  "\(self.gameData.host.name!), \(self.gameData.host.age!)"
        pointsLabel.textAlignment = .center
        pointsLabel.font = UIFont(name: "Gilroy-Extrabold", size: 18)
        pointsLabel.textColor = UIColor(named: "customGray")
        self.navigationItem.titleView = pointsLabel
    }
    
    fileprivate func setupPointsLabel() {
        let pointsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        pointsLabel.text = "2350"
        pointsLabel.textAlignment = .right
        pointsLabel.font = UIFont(name: "GorgaGrotesque-Bold", size: 23)
        pointsLabel.textColor = UIColor(named: "mainColor")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pointsLabel)
    }
    
    @objc func leaveAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func handleKeyboardLogic() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.keyboardWillHide))
        gesture.direction = .down
        self.view.addGestureRecognizer(gesture)
        self.chatView.addGestureRecognizer(gesture)
        self.chatView.delegate = self
    }
    
    fileprivate func setupMainView() {
        view.addSubview(mainView)
        view.backgroundColor = .white
        setupChatView()
        setupCreateMessageView()
        mainView.fillSuperView()
        createMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        setupHeaderView()
    }
    
    fileprivate func setupChatView() {
        chatView.dataSource = self
        setupEndEditingGesture()
        chatView.delegate = self
        chatView.register(ChatMessageCell.self, forCellWithReuseIdentifier: messageId)
        chatView.register(ChatInfoCell.self, forCellWithReuseIdentifier: infoId)
    }
    
    fileprivate func setupHeaderView() {
        view.addSubview(headerView)
        headerView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor)
        headerView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    fileprivate func setupCreateMessageView() {
        createMessage.messageField.delegate = self
        createMessage.sendButton.addTarget(self, action: #selector(self.addMessage), for: .touchUpInside)
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Logic
    @objc func addMessage() {
        if let messageText = createMessage.messageField.text {
            self.createMessage.messageField.text = ""
            self.createMessage.sendButton.isEnabled = false
        }
    }
    
    let bottomSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    
    var isKeyboardShowing = false
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isKeyboardShowing = false
        view.endEditing(true)
        createMessage.frame.origin.y = (view.safeAreaLayoutGuide.layoutFrame.height - createMessage.frame.height)
        chatView.frame.origin.y = (view.safeAreaLayoutGuide.layoutFrame.height - chatView.frame.height - createMessage.frame.height)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if isKeyboardShowing == false {
                let keyboardHeight = keyboardSize.height
                chatView.frame.origin.y -= keyboardHeight - bottomSafeArea
                createMessage.frame.origin.y -= keyboardHeight - bottomSafeArea
                isKeyboardShowing = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createMessage.messageField.resignFirstResponder()
        return true
    }
    
    func fetchMessages() {
        self.messages.insert(contentsOf: messages, at: 0)
        self.chatView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentMessage = messages[indexPath.item]
        switch currentMessage.type {
        case .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageId, for: indexPath) as! ChatMessageCell
            cell.doesBreakTheSenderChain = true
            cell.message = currentMessage
            return cell
        case .info:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoId, for: indexPath) as! ChatInfoCell
            cell.message = currentMessage
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch messages[indexPath.item].type {
        case .text: return CGSize(width: self.chatView.frame.width, height: 100)
        case .info: return CGSize(width: self.chatView.frame.width, height: 45)
        default:    return CGSize(width: self.chatView.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    func setupEndEditingGesture() {
        let endEditingGesture = UISwipeGestureRecognizer(target: self, action: #selector(textFieldShouldReturn(_:)))
        endEditingGesture.direction = .up
        chatView.addGestureRecognizer(endEditingGesture)
        endEditingGesture.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
