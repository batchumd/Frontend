//
//  CircularImageView.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/5/21.
//

import Foundation
import UIKit

class CircularImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
}
