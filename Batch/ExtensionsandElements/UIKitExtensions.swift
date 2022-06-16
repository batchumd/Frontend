//
//  UIKitExtensions.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/8/22.
//

import UIKit

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
    
}

class ATCTextField: UITextField {
    let padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rightpadding = self.rightView?.bounds.width ?? 0
        return bounds.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: rightpadding))
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
