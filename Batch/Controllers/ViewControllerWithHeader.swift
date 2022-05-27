//
//  ViewControllerWithHeader.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/23/22.
//

import UIKit

class ViewControllerWithHeader: UIViewController {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 30)
        label.textColor = UIColor(named: "customGray")
        return label
    }()
    
    func setupHeader(title: String) {
        view.addSubview(headerLabel)
        headerLabel.text = title
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    }

}
