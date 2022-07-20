//
//  StandingsViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/19/22.
//

import Foundation
import UIKit

class RankingsViewController: ViewControllerWithHeader {
    
    let profiles: [User] = []
    
    //MARK: UI Elements
    let standingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    lazy var genderFilter: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Female", "Male"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = UIColor(named: "mainColor")
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "customGray")!,
                                                 NSAttributedString.Key.font: UIFont(name: "Brown-Bold", size: 14)!], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitle(Gender.bachelorette.pluralized, forSegmentAt: 0)
        segmentedControl.setTitle(Gender.bachelor.pluralized, forSegmentAt: 1)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    let noRankingsGraphic = GraphicInfoView(type: .noRankings)
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader(title: "Rankings")
        setupGenderFilter()
        if profiles.isEmpty {
            setupGraphic(type: .noRankings)
        } else {
            setupStandingsCollectionView()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Standings"
        self.tabBarItem = UITabBarItem.init(title: nil, image: UIImage(named: "StandingsIcon"), tag: 3)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    }

    fileprivate func setupStandingsCollectionView() {
        standingsCollectionView.delegate = self
        standingsCollectionView.dataSource = self
        view.addSubview(standingsCollectionView)
        standingsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        standingsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        standingsCollectionView.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: margin / 2).isActive = true
        standingsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setupGenderFilter() {
        //Setup genderFilter
        view.addSubview(genderFilter)
        genderFilter.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
        genderFilter.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        genderFilter.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        genderFilter.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    //MARK: Business Logic
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
           
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
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCell
        cell.rankLabel.text = String(indexPath.row + 1)
        cell.user = profiles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
