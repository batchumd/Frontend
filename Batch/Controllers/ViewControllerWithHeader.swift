//
//  ViewControllerWithHeader.swift
//  Batch
//
//  Created by Kevin Shiflett on 5/23/22.
//

import UIKit

class ViewControllerWithHeader: UIViewController {
    
    let margin: CGFloat = 30
        
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
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin / 2).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
    
    }
    
    func setupGraphic(type: GraphicType) {
        let graphicView = GraphicInfoView(type: type)
        let contentView = UIView()
        self.view.addSubview(contentView)
        contentView.anchor(top: headerLabel.bottomAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
        contentView.addSubview(graphicView)
        graphicView.translatesAutoresizingMaskIntoConstraints = false
        graphicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        graphicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        graphicView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

}

