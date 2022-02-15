//
//  ViewController.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit

class ViewController: UIViewController {
    
    let mainView = UIView()
    
    let header: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Join a game and play!\nLast one remaining wins.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor(named: "mainColor") ?? UIColor.purple, range: NSRange(location:21,length:25))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Gilroy-ExtraBold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "BatchLogo")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nearbyInfoButton = nearbyButton(numberOnline: 210, distance: 19)
    
    let gamesPlayed = statBox(value: 10, name: "Games Played")
    
    let gamesWon = statBox(value: 2, name: "Wins")
    
    let stackView = UIStackView()
    
    let playButton: UIButton = {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.cornerStyle = .capsule
            config.background.backgroundColor = UIColor(named: "mainColor")
            var text = AttributedString.init("Find a Game")
            text.font = UIFont(name: "Gilroy-ExtraBold", size: 20)
            text.foregroundColor = UIColor.white
            config.attributedTitle = text
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            button.configuration = config
        } else {
            // Fallback on earlier versions
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        mainView.backgroundColor = .white
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mainView.addSubview(header)
        header.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 15).isActive = true
        header.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        mainView.addSubview(nearbyInfoButton)
        nearbyInfoButton.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20).isActive = true
        nearbyInfoButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        setupStatsView()
        let graphicView = UIImageView(image: UIImage(named: "homeGraphic"))
        graphicView.contentMode = .scaleAspectFit
        graphicView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(graphicView)
        graphicView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: -20).isActive = true
        graphicView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 20).isActive = true
        graphicView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30).isActive = true
        mainView.addSubview(playButton)
        playButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10).isActive = true
        playButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30).isActive = true
        playButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30).isActive = true
    }
    
    func setupStatsView() {
        stackView.addArrangedSubview(gamesPlayed)
        stackView.addArrangedSubview(gamesWon)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        stackView.axis = .horizontal
        stackView.spacing = 50
        stackView.topAnchor.constraint(equalTo: nearbyInfoButton.bottomAnchor, constant: 30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupNavigationBar() {
        navigationItem.titleView = titleImageView
        navigationController?.view.backgroundColor = .white
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        let myBatches = UIButton()
//      myBatches.addTarget(self, action: #selector(showPlans), for: .touchUpInside)
        myBatches.setImage(UIImage(named: "MessagesIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myBatches)
    }
}

