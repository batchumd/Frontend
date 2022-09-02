//
//  ChatView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation
import UIKit

class MessagesView: UICollectionView {
    
    var selectionDelegate: UserSelectionDelegate?
    
    var createMessageHeight: Double? {
        didSet {
            reloadData()
        }
    }
    
    var responses: [Message] = []
    
    fileprivate let responseID = "response"
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        layout.minimumLineSpacing = 10
        return layout
    }()
       
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
           
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        backgroundColor = .clear
        self.collectionViewLayout = self.flowLayout
        self.register(ChatMessageCell.self, forCellWithReuseIdentifier: responseID)
        self.dataSource = self
        self.delegate = self
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func checkIfNextMessageIsFromSameUser(_ indexPath: IndexPath) -> Bool {
        if (indexPath.row != responses.count - 1) && (responses[indexPath.row].sender_id == responses[indexPath.row + 1].sender_id) {
            return true
        } else {
            return false
        }
    }
    
}

extension MessagesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentMessage = responses[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.responseID, for: indexPath) as! ChatMessageCell
        cell.selectionDelegate = self
//        cell.messageDelegate = self
        if checkIfNextMessageIsFromSameUser(indexPath) {
            cell.doesBreakTheSenderChain = false
        } else {
            cell.doesBreakTheSenderChain = true
        }
                
        cell.message = currentMessage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: (self.createMessageHeight ?? 0) + 10, left: 0, bottom: 20, right: 0)
    }
}

extension MessagesView: UserSelectionDelegate {
    
    func userSelected(user: User) {
        self.selectionDelegate?.userSelected(user: user)
    }
    
}
