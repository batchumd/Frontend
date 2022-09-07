//
//  UserPhotosCollectionView.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/12/22.
//

import UIKit

protocol PhotoSelectionDelegate {
    func photoCellSelected(isEmpty: Bool)
}

class UserPhotosCollectionView: UICollectionView {

    var selectedCell: UserPhotoCell? = nil
    
    var photoSelectionDelegate: PhotoSelectionDelegate?
    
    private var minimumSpacing: CGFloat = 20
    
    private var edgeInsetPadding: CGFloat = 55
    
    //MARK: UI Lifecycle Methods
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.register(UserPhotoCell.self, forCellWithReuseIdentifier: "photo")
        backgroundColor = .clear
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UserPhotosCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath as IndexPath) as! UserPhotoCell
        cell.imageURL = nil
        if let images = LocalStorage.shared.currentUserData?.profileImages {
            if indexPath.row < images.count {
                let imageURL = images[indexPath.row]
                cell.imageURL = imageURL
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 18, left: edgeInsetPadding, bottom: 0, right: edgeInsetPadding)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.cellForItem(at: indexPath) as! UserPhotoCell
        self.selectedCell = cell
        photoSelectionDelegate?.photoCellSelected(isEmpty: cell.imageURL == nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - (minimumSpacing + (edgeInsetPadding * 2))) / 2
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return minimumSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return minimumSpacing
        }
}
