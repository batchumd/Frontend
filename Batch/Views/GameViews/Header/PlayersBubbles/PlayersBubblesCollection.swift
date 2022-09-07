//
//  PlayersBubblesCollection.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import UIKit

protocol UserSelectionDelegate {
    func userSelected(user: User)
}

class PlayersCollectionView: UICollectionView, GridLayoutDelegate, UICollectionViewDelegate {
    
    //MARK: Variables
    
    var cellSpacing: CGFloat!
    
    var selectionDelegate: UserSelectionDelegate?
    
    var host: User? {
        didSet {
            self.reloadItems(at: [IndexPath(item: 0, section: 1)])
        }
    }
    
    var players: [User]? {
        didSet {
            guard let players = players else { return }
            
            /* If the players are greater than 3 then we want to split the array
            since each section of players should contain max 3 */
            if players.count > 3 {
                let firstPart = Array(players[0..<3])
                let secondPart = Array(players[3..<players.count])
                self.playersSplitted = (firstPart, secondPart)
            } else {
                // If the players array length is less than or equal to 3 then we just set the second array as empty
                self.playersSplitted = (players, [])
            }
        }
    }
    
    var playersSplitted: ([User], [User])? {
        didSet {
            self.reloadData()
        }
    }
    
    let gridLayout = GridLayout()
    
    let friendCellId = "FriendCellId"
    
    //MARK: Methods
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: gridLayout)
        
        // Set delegates
        gridLayout.delegate = self
        delegate = self
        dataSource = self
                
        // Set grid layout variables
        gridLayout.itemSpacing = 10
        gridLayout.fixedDivisionCount = 10
        gridLayout.scrollDirection = .horizontal
        
        // Register cells for reuse for sections
        register(UserBubbleCell.self, forCellWithReuseIdentifier: "host")
        register(UserBubbleCell.self, forCellWithReuseIdentifier: "firstUserSet")
        register(UserBubbleCell.self, forCellWithReuseIdentifier: "secondUserSet")
        
        isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
        if indexPath.section == 0 || indexPath.section == 2 {
            return 5
        }
        return 10
    }
    
    func itemFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return fixedDimension
    }
    
    func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 0
    }
}


extension PlayersCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstUserSet", for: indexPath as IndexPath) as! UserBubbleCell
            cell.user = nil
            if let playersSplitted = playersSplitted {
                // If the current index does not have a user then we don't populate it
                if indexPath.row < playersSplitted.0.count {
                    cell.user = playersSplitted.0[indexPath.row]
                }
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "host", for: indexPath as IndexPath) as! UserBubbleCell
            cell.user = nil
            cell.user = host
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondUserSet", for: indexPath as IndexPath) as! UserBubbleCell
            cell.user = nil
            if let playersSplitted = playersSplitted {
                if indexPath.row < playersSplitted.1.count {
                    cell.user = playersSplitted.1[indexPath.row]
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected cell and its user variable and pass it to the selectionDelegate
        let cell = collectionView.cellForItem(at: indexPath) as? UserBubbleCell
        guard let user = cell?.user else { return }
        selectionDelegate?.userSelected(user: user)
    }
}
