//
//  UIKitExtensions.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/8/22.
//

import UIKit
import Kingfisher

//MARK: UIImage
extension UIImage {

    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    var roundMyImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UIImageView {
    func setCachedImage(urlstring: String, size: CGSize, complete: @escaping () -> ()) {
        let processor = ResizingImageProcessor(referenceSize: size)
        self.kf.setImage(
            with: URL(string: urlstring),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(2)),
                .cacheOriginalImage
            ])
        complete()
    }
}

class ATCTextField: UITextField {
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: self.rightView?.bounds.width ?? 0))
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right:  self.rightView?.bounds.width ?? 0))
    }
}

//MARK: UITextField
extension UITextField {
    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

//MARK: String
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

class circularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        backgroundColor = .systemGray5
    }
}
