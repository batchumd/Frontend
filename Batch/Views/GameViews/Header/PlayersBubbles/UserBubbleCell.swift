//
//  UserBubbleCell.swift
//  Batch
//
//  Created by Kevin Shiflett on 9/1/22.
//

import UIKit

class UserBubbleCell: UICollectionViewCell {
        
    var user: User? {
        didSet {
            guard let user = user else {
                // When set for nil for reuse purposes we clear the image and remove it from UI
                self.userImageView.image = nil
                self.userImageView.removeFromSuperview()
                return
            }
            userImageView.setCachedImage(urlstring: user.profileImages[0], size: self.bounds.size) {}
            self.setupUserImageView()
        }
    }
    
    //MARK: UI Components
    
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    
    fileprivate func setupUserImageView() {
        self.addSubview(userImageView)
        userImageView.fillSuperView()
        userImageView.centerInsideSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
