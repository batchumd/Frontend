//
//  UserPhotoCell.swift
//  Batch
//
//  Created by Kevin Shiflett on 7/12/22.
//

import UIKit

class UserPhotoCell: UICollectionViewCell {
    
    var imageURL: String? {
        didSet {
            
            if let imageURL = imageURL {
                self.imageView.setCachedImage(urlstring: imageURL, size: self.bounds.size) {
                    self.progressView.isHidden = true
                }
            } else {
                self.imageView.image = nil
                self.progressView.isHidden = true
            }
        }
    }
    
    let progressView = ProgressView(lineWidth: 6.0, dark: true)
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor(named: "mainColor")?.cgColor
        dashedBorder.lineDashPattern = [8, 8]
        dashedBorder.lineWidth = 3
        dashedBorder.frame = self.bounds
        dashedBorder.fillColor = nil
        dashedBorder.cornerRadius = 10
        dashedBorder.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        self.layer.addSublayer(dashedBorder)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperView()
        
        self.addSubview(progressView)
        progressView.isHidden = true
        progressView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        progressView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func startLoadingProgress() {
        progressView.isHidden = false
        progressView.animateStroke()
        progressView.animateRotation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
