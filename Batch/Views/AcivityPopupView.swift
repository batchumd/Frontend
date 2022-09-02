//
//  AcivityPopupView.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/4/22.
//

import Foundation
import UIKit

class ActivityPopupView: UIView {
    
    let activityIndicator = ProgressView(lineWidth: 5, dark: false)
    
    let activityContainer = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-Extrabold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var title: String! {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 15
        self.backgroundColor = .black.withAlphaComponent(0.5)
        
        let contentView = UIView()
        self.activityContainer.addSubview(activityIndicator)
        activityIndicator.fillSuperView()
        contentView.addSubview(activityContainer)
        activityContainer.translatesAutoresizingMaskIntoConstraints = false
        activityContainer.widthAnchor.constraint(equalToConstant: 75).isActive = true
        activityContainer.heightAnchor.constraint(equalToConstant: 75).isActive = true
        activityContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        activityContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: activityContainer.bottomAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        self.addSubview(contentView)
        contentView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        contentView.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor)
        contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        activityIndicator.animateStroke()
        activityIndicator.animateRotation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
