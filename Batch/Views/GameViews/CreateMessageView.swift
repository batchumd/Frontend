//
//  CreateMessageView.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import UIKit

class CreateMessageView: UIView {
    
    let messageField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.layer.cornerRadius = 5
        field.placeholder = "Type a message..."
        field.font = UIFont(name: "Avenir-Medium", size: 18)
        return field
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor(named: "mainColor"), for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadow(radius: 12, offset: CGSize(width: 0, height: -20), opacity: 0.08)
        setupMessageField()
        setupSendButton()
    }
    
    fileprivate func setupMessageField() {
        addSubview(messageField)
        messageField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        messageField.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        messageField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.75).isActive = true
    }
    
    @objc func textFieldDidChange() {
        sendButton.isEnabled = messageField.text != "" ? true : false
    }
    
    fileprivate func setupSendButton() {
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, bottom: bottomAnchor, leading: messageField.trailingAnchor, trailing: trailingAnchor)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
