//
//  GameTimerView.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/9/22.
//

import Foundation
import UIKit

class GameTimerLabel: UILabel {
    
    init(fontSize: CGFloat, dark: Bool) {
        super.init(frame: .zero)
        textColor = dark ? .white : UIColor(named: "mainColor")
        backgroundColor = dark ? UIColor(named: "mainColor") : .white
        font = UIFont(name: "Gilroy-Extrabold", size: fontSize)
        textAlignment = .center
        text = "-"
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        return CGSize(width: originalContentSize.width + 20, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CountdownActionLabel: UIView {
    
    var joiningStatus: FetchingState? {
        didSet {
//            if joiningStatus == .fetching {
//                self.checkIcon.isHidden = true
//                self.label.text = "Checking you in..."
//            }
//            if joiningStatus == .fetched {
//                self.checkIcon.isHidden = false
//                self.label.text = "You're checked in!"
//            }
//            if joiningStatus == .notFetched {
//                self.checkIcon.isHidden = true
//                self.label.text = ""
//            }
//            self.invalidateIntrinsicContentSize()
        }
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [label])
    
    let checkIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "check"))
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = true
        return icon
    }()
    
    let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        let contentView = UIView()
        self.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        stackView.spacing = 5
        stackView.fillSuperView(padding: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        contentView.fillSuperView()
        contentView.backgroundColor = UIColor(red: 190 / 255 , green: 83 / 255, blue: 232 / 255, alpha: 1.0)
        checkIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkIcon.widthAnchor.constraint(equalTo: checkIcon.heightAnchor).isActive = true
        layer.shadowRadius = 5
        label.textColor = .white
        label.layer.masksToBounds = true
        label.font = UIFont(name: "Brown-bold", size: 17)
        label.textAlignment = .center
        guard let userData = LocalStorage.shared.currentUserData else { return }
        label.text = userData.gender == .bachelorette ? "Be The Bachelorette @ 9pm" : "Come play @ 9pm EST"
        translatesAutoresizingMaskIntoConstraints = false
        self.addShadow()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
