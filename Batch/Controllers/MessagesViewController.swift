//
//  ViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit

class MessagesViewController: ViewControllerWithHeader {
    
    let messages = [
        Message(sender: User(name: "Tom", age: 23, image: UIImage(named: "nicole")!, points: 233), content: "Hey whats up!", time: Date(timeIntervalSinceNow: 2333))
    ]
    
    //MARK: UI Elements
    let messagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    let searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search 2 matches"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.font = UIFont(name: "Avenir", size: 17)
        textField.textColor = .darkGray
        textField.layer.cornerRadius = 8
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 35))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup the views
        setupHeader(title: "Messages")
        setupSearchBar()
        setupMessagesCollectionView()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem.init(title: "Messages", image: UIImage(named: "MessagesIcon"), tag: 2)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Gilroy-ExtraBold", size: 11)!], for: .normal)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
    }
    
    fileprivate func setupMessagesCollectionView() {
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
        view.addSubview(messagesCollectionView)
        messagesCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        messagesCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        messagesCollectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 15).isActive = true
        messagesCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 15).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//CollectionView Logic
extension MessagesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MessageCell
        cell.message = self.messages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
