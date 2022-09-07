//
//  GraphicInfoView.swift
//  A view used throughout the app to show a simple graphic, title, and subtitle
//  Batch
//
//  Created by Kevin Shiflett on 6/26/22.
//

import Foundation
import UIKit

class GraphicInfoView: UIView {
        
    let graphicImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let graphicTitle: UILabel = {
        let label = UILabel()
        label.text = "Start Playing"
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-Extrabold", size: 24)
        label.textColor = UIColor(named: "mainGray")
        return label
    }()
    
    let graphicSubTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: "You’ll be able to message hosts who choose you and players you choose if you host.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray2, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Brown-bold", size: 18)!, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [graphicImage, graphicTitle, graphicSubTitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .vertical
        return stackView
    }()
    
    init(type: GraphicType) {
        self.graphicImage.image = type.graphicImage
        self.graphicTitle.text = type.title
        self.graphicSubTitle.text = type.subtitle
        super.init(frame: CGRect.zero)
        self.addSubview(stackView)
        stackView.fillSuperView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum GraphicType {
    case noRankings
    case noMatches
    
    var graphicImage: UIImage {
        switch self {
            case .noRankings: return UIImage(named: "norankings")!
            case .noMatches: return UIImage(named: "wingamegraphic")!
        }
    }
    
    var title: String {
        switch self {
            case .noRankings: return "Coming Soon"
            case .noMatches: return "Start Playing"
        }
    }
    
    var subtitle: String {
        switch self {
            case .noRankings: return "Once enough games are played, you'll be able to see user rankings here."
            case .noMatches: return "You’ll be able to message hosts who choose you and players you choose if you host."
        }
    }
}
