//
//  StandingsViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/19/22.
//

import Foundation
import UIKit

class RankingsViewController: ViewControllerWithHeader {
    
    let profiles = [
                    User(name: "Nicole", age: 21, image: UIImage(named: "nicole")!, points: 938),
                    User(name: "Layla", age: 20, image: UIImage(named: "layla")!, points: 129),
                    User(name: "Ariana", age: 19, image: UIImage(named: "ariana")!, points: 420),
                    User(name: "Lauren", age: 22, image: UIImage(named: "lauren")!, points: 500)
    ]
    
    let standingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    let genderFilter: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Female", "Male"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = UIColor(named: "mainColor")
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "customGray")!, NSAttributedString.Key.font: UIFont(name: "Brown-Bold", size: 14)!], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return segmentedControl
    }()
    
    fileprivate func setupStandingsCollectionView() {
        //Setup collectionView
        standingsCollectionView.delegate = self
        standingsCollectionView.dataSource = self
        view.addSubview(standingsCollectionView)
        standingsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        standingsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        standingsCollectionView.topAnchor.constraint(equalTo: self.genderFilter.bottomAnchor, constant: 15).isActive = true
        standingsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setupGenderFilter() {
        //Setup genderFilter
        view.addSubview(genderFilter)
        genderFilter.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
        genderFilter.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        genderFilter.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader(title: "Rankings")
        
        setupGenderFilter()
        
        setupStandingsCollectionView()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Standings"
        self.tabBarItem = UITabBarItem.init(title: "Rankings", image: UIImage(named: "StandingsIcon"), tag: 3)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Gilroy-ExtraBold", size: 11)!], for: .normal)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RankingsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCell
        cell.rankLabel.text = String(indexPath.row + 1)
        cell.user = self.profiles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
}
