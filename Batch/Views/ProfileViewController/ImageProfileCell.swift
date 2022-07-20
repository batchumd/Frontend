//
//  ImageProfileCell.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/19/22.
//

import UIKit

class ImageProfileCell: UICollectionViewCell {
    
    let profileCardView = ProfileCardView()

    var imageURL: String? {
        didSet {
            guard let imageURL = imageURL else {return}
            profileCardView.profileImage.setCachedImage(urlstring: imageURL, size: self.bounds.size) {}
        }
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.addSubview(profileCardView)
        profileCardView.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
