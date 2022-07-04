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
    
    let filtersButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "filter")?.withTintColor(.systemGray2), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemGray2
        button.setTitle("Filter", for: .normal)
        button.titleLabel?.font = UIFont(name: "Brown-bold", size: 18)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        button.setTitleColor(UIColor.systemGray2, for: .normal)
        return button
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
        self.tabBarItem = UITabBarItem.init(title: "Rankings", image: UIImage(named: "StandingsIcon"), tag: 3)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Gilroy-ExtraBold", size: 11)!], for: .normal)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
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
        view.addSubview(filtersButton)
        filtersButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: margin / 2, left: margin, bottom: 0, right: margin))
        filtersButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
