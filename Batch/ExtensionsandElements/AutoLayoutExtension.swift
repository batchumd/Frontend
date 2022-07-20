//
//  AutoLayoutExtension.swift
//  Batch
//
//  Created by Kevin Shiflett on 6/16/22.
//

import Foundation
import UIKit

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView {
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperView(useSafeAreaLayouts: Bool = true, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            
            let fillToTop = useSafeAreaLayouts ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
            let fillToBottom = useSafeAreaLayouts ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
            let fillToLeft = useSafeAreaLayouts ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor
            let fillToRight = useSafeAreaLayouts ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor
            
            topAnchor.constraint(equalTo: fillToTop, constant:  padding.top).isActive = true
            bottomAnchor.constraint(equalTo: fillToBottom, constant: -(padding.bottom)).isActive = true
            leadingAnchor.constraint(equalTo: fillToLeft, constant: padding.left).isActive = true
            trailingAnchor.constraint(equalTo: fillToRight, constant: -(padding.right)).isActive = true

        }
    }
    
    func centerInsideSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}
