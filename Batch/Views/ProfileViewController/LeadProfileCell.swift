//
//  LeadProfileCell.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/19/22.
//

import UIKit

class LeadProfileCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let user = user else {return}
            guard let currentUID = LocalStorage.shared.currentUserData?.uid else { return }
            if user.uid == currentUID {
                self.setupSettingsButton()
            }
            profileCardView.nameLabel.text = user.name + ", " + String(user.age)
            profileCardView.profileImage.setCachedImage(urlstring: user.profileImages.first!, size: self.bounds.size) {}
        }
    }
    
    var preferencesDelegate: PreferencesDelegate?
    
    let profileCardView = ProfileCardView(withContent: true)
    
    fileprivate lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "editbutton"), for: .normal)
        button.addTarget(self, action: #selector(showPreferences), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.addSubview(profileCardView)
        profileCardView.fillSuperView()
    }
    
    fileprivate func setupSettingsButton() {
        profileCardView.addSubview(settingsButton)
        settingsButton.anchor(top: profileCardView.topAnchor, bottom: nil, leading: nil, trailing: profileCardView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15))
    }
    
    @objc func showPreferences() {
        self.preferencesDelegate?.showPreferences()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
