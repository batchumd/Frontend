//
//  ViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit

class MessagesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Messages"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

