//
//  ChatView.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/26/22.
//

import Foundation
import UIKit

class ChatView: UIView {
    
    let responsesView = MessagesView()

    let createMessage = CreateMessageView()
    
    init() {
        super.init(frame: .zero)
        self.addSubview(responsesView)
        self.responsesView.fillSuperView()
        self.addSubview(createMessage)
        self.createMessage.anchor(top: nil, bottom: self.safeAreaLayoutGuide.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        responsesView.createMessageHeight = createMessage.bounds.size.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
