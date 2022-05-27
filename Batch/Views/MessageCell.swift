//
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class MessageCell: UICollectionViewCell {

    var message: Message! {
        didSet {
            profileImageView.image = message.sender.image
            nameAgeLabel.text = message.sender.name + ", " + String(message.sender.age)
            contentPreviewLabel.text = message.content
            if #available(iOS 15.0, *) {
                timeLabel.text = message.time.formatted(.dateTime.month(.abbreviated))
            }
        }
    }
    
    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate let nameAgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "customGray")
        label.font = UIFont(name: "Brown-bold", size: 20)
        return label
    }()
    
    fileprivate let contentPreviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 19)
        label.textColor = UIColor(named: "customGray")
        return label
    }()
    
    fileprivate let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GorgaGrotesque-Bold", size: 19)
        label.textColor = UIColor(named: "mainColor")
        return label
    }()
    
    lazy var textStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameAgeLabel, contentPreviewLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        
        //Setup stackview
        self.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        self.addSubview(textStack)
        textStack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        textStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //Setup points label
        self.addSubview(timeLabel)
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
