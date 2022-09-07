//
//  ProfileViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/17/22.
//

import UIKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User? {
        didSet {
            self.collectionView.reloadData()
        }
    }
        
    private var minimumSpacing: CGFloat = 15
        
    override func viewDidLoad() {
        self.collectionView.register(LeadProfileCell.self, forCellWithReuseIdentifier: "lead")
        self.collectionView.register(StatsProfileCell.self, forCellWithReuseIdentifier: "stats")
        self.collectionView.register(ImageProfileCell.self, forCellWithReuseIdentifier: "image")
    }
    
    init(user: User?) {
        self.user = user
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
        self.tabBarItem = UITabBarItem.init(title: nil, image: UIImage(named: "profile"), tag: 1)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let user = user else {
            return 0
        }

        
        switch section {
            case 0: return user.profileImages.isEmpty ? 0 : 1
            case 1: return 1
            case 2: return (user.profileImages.count - 1)
            default: return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lead", for: indexPath as IndexPath) as! LeadProfileCell
            cell.user = self.user
            cell.preferencesDelegate = self
            return cell
            
        case 1:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stats", for: indexPath as IndexPath) as! StatsProfileCell
            cell.stats = ["won": self.user?.gamesWon ?? 0, "points": self.user?.points ?? 0, "rounds": self.user?.roundsPlayed ?? 0]
            return cell
            
        case 2:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath as IndexPath) as! ImageProfileCell
            cell.imageURL = self.user?.profileImages[indexPath.row + 1]
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width - (minimumSpacing * 4)
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: width * 1.4)
        case 1:
            return CGSize(width: width, height: 100)
        case 2:
            return CGSize(width: width, height: width * 1.4)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: minimumSpacing, left: 0, bottom: 0, right: 0)
        case 1:
            return  UIEdgeInsets(top: minimumSpacing, left: 0, bottom: minimumSpacing, right: 0)
        case 2:
            return  UIEdgeInsets(top: 0, left: 0, bottom: minimumSpacing, right: 0)
        default:
            return .zero
        }
    }
    
}

extension ProfileViewController: PreferencesDelegate {
    func dismissPreferences() {
        UIApplication.shared.keywindow?.rootViewController?.viewDidAppear(false)
    }
    
    func showPreferences() {
        let preferencesController = PreferencesViewController()
        preferencesController.preferencesDelegate = self
        let vc = UINavigationController(rootViewController: preferencesController)
        UIApplication.shared.keywindow?.rootViewController?.present(vc, animated: true)
    }
}

protocol PreferencesDelegate {
    func showPreferences()
    func dismissPreferences()
}
