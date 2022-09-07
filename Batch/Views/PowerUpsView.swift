//
//  PowerUpsView.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/3/22.
//

import Foundation
import UIKit

class PowerupsView: UIView {
    
    let refreshGamesButton: UIView = {
        let view = UIView()
        let imageView = CircularImageView(image: UIImage(named: "refresh_games"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.image!.size.width / 2
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.fillSuperView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadow()
        view.backgroundColor = .clear
        return view
    }()
    
    let doublePointsButton: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "double_points"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.image!.size.width / 2
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.fillSuperView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadow()
        view.backgroundColor = .clear
        return view
    }()
    
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.layer.cornerRadius = 25
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let stackView = UIStackView(arrangedSubviews: [refreshGamesButton, doublePointsButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        self.addSubview(stackView)
        stackView.fillSuperView(padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
