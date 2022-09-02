//
//  CreateMessageView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import UIKit

class CreateMessageView: UIStackView {
    
    let gamerTimerLabel = GameTimerLabel(fontSize: 21, dark: true)
    
    let messageField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.layer.cornerRadius = 5
        field.placeholder = "Type a message..."
        field.font = UIFont(name: "Avenir-Medium", size: 18)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "send"), for: .normal)
        button.isHidden = true
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.spacing = 10
        self.addArrangedSubview(gamerTimerLabel)
        gamerTimerLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.addArrangedSubview(messageField)
        self.addArrangedSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backgroundColor = .white
        self.axis = .horizontal
        self.layer.cornerRadius = 25
        self.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 15)
        self.isLayoutMarginsRelativeArrangement = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addShadow(radius: 12, offset: CGSize(width: 0, height: -20), opacity: 0.08)
        setupMessageField()
    }
    
    fileprivate func setupMessageField() {
        messageField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        messageField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.75).isActive = true
    }
    
    @objc func textFieldDidChange() {
        sendButton.isHidden = messageField.text == "" ? true : false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
