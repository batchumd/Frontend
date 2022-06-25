//
//  PlayersBubblesCollection.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import UIKit

extension Array {
    func split() -> [[Element]] {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}

class PlayersCollectionView: UICollectionView, GridLayoutDelegate, UICollectionViewDelegate {
    
    var cellSpacing: CGFloat!
    
    var host: User! {
        didSet {
            reloadData()
        }
    }
    
    var players: [User]! {
        didSet {
            let remainingToFill = 8 - players.count
            for _ in 0...remainingToFill {
                players.append(try! User()!)
            }
            self.playersSplitted = players.split()
            dataSource = self
            reloadData()
        }
    }
    
    var playersSplitted = [[User]]()
    
    let gridLayout = GridLayout()
    
    let friendCellId = "FriendCellId"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: gridLayout)
        gridLayout.delegate = self
        delegate = self
        isScrollEnabled = false
        register(userBubbleCell.self, forCellWithReuseIdentifier: "users")
        gridLayout.delegate = self
        gridLayout.itemSpacing = 10
        gridLayout.fixedDivisionCount = 10
        gridLayout.scrollDirection = .horizontal
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
        return playersSplitted[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "users", for: indexPath as IndexPath) as! userBubbleCell
        if indexPath.section == 0 {
            cell.user = playersSplitted[0][indexPath.row]
        } else if indexPath.section == 1 {
            cell.user = host
        } else if indexPath.section == 2 {
            print(playersSplitted)
            cell.user = playersSplitted[1][indexPath.row]
        }
        return cell
    }
}

class userBubbleCell: UICollectionViewCell {
        
    var user: User! {
        didSet {
            let memberImage = UIImageView()
            self.addSubview(memberImage)
            memberImage.fillSuperView()
//            memberImage.image = user.image
            memberImage.centerInsideSuperView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
