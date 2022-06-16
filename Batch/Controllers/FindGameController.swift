//
//  FindGameController.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class FindGameController: CustomViewControllerWithNav, UICollectionViewDelegate {
    
    private var minimumSpacing: CGFloat = 10

    private var edgeInsetPadding: CGFloat = 20
    
    let profiles = [
                    User(name: "Nicole", age: 21, image: UIImage(named: "nicole")!, points: 938),
                    User(name: "Layla", age: 20, image: UIImage(named: "layla")!, points: 129),
                    User(name: "Ariana", age: 19, image: UIImage(named: "ariana")!, points: 420),
                    User(name: "Lauren", age: 22, image: UIImage(named: "lauren")!, points: 500)
    ]
    
    //MARK: UI Elements
    let informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Finding Bachelorettes..."
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 22)
        label.textAlignment = .center
        label.textColor = UIColor(named: "customGray")
        return label
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Make your pick before the game is full."
        label.font = UIFont(name: "Brown-Bold", size: 15)
        label.textAlignment = .center
        label.textColor = UIColor(named: "customGray")
        return label
    }()
    
    let gameCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: UI Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        gameCollectionView.register(ProfileCard.self, forCellWithReuseIdentifier: "result")
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        setupLayout()
        navigationItem.setRightBarButton(nil, animated: true)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(informationLabel)
        informationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(tipLabel)
        tipLabel.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 10).isActive = true
        tipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(gameCollectionView)
        gameCollectionView.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 15).isActive = true
        gameCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gameCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gameCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}

extension FindGameController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "result", for: indexPath as IndexPath) as! ProfileCard
        cell.user = profiles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let height = collectionView.bounds.size.height - ((((collectionView.bounds.size.width / 2) * 1.7) * 2) - (minimumSpacing + (edgeInsetPadding)))
        let inset = UIEdgeInsets(top: height, left: 20, bottom: 0, right: 20)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - (minimumSpacing + (edgeInsetPadding * 2))) / 2
        return CGSize(width: width, height: width * 1.7)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return minimumSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return minimumSpacing
        }
}
