//
//  SettingsCell.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/27/22.
//

import UIKit

class SettingsCell: UITableViewCell {
        
    lazy var content = self.defaultContentConfiguration()
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            toggleSwitch.isHidden = !sectionType.containsSwitch
            viewIcon.isHidden = sectionType.containsSwitch
            toggleSwitch.isUserInteractionEnabled = true
            self.content.text = sectionType.description
            self.content.secondaryText = sectionType.result?.map({$0.rawValue.capitalizingFirstLetter()}).joined(separator: ", ")
            self.contentConfiguration = content
        }
    }
    
    lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = true
        toggleSwitch.onTintColor = UIColor(named: "mainColor")
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.addTarget(self, action: #selector(handleSwitchChange), for: .valueChanged)
        return toggleSwitch
    }()
    
    let viewIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "next")?.withTintColor(UIColor(named: "customGray")!))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(toggleSwitch)
        selectionStyle = UITableViewCell.SelectionStyle.none
        self.addSubview(viewIcon)
        toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        viewIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        viewIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        content.textProperties.color = UIColor(named: "customGray")!
        content.textProperties.font = UIFont(name: "Brown-bold", size: 16)!
        content.secondaryTextProperties.color = UIColor.systemGray
        content.secondaryTextProperties.font = UIFont(name: "Avenir", size: 15)!
    }
    
    @objc func handleSwitchChange() {
        print("valueChanged")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UISwitch {
    func toggle() {
        self.isOn = self.isOn ? false : true
        self.sendActions(for: .valueChanged)
    }
}
