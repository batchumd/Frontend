//
//  CustomViewControllerWithNav.swift
//  Batch
//
//  Created by Kevin Shiflett on 2/14/22.
//

import UIKit

class CustomNavController: UINavigationController {
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "BatchLogo")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let profileButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profile")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    let messagesButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "MessagesIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        return imageView
    }()
            
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
        if let root = self.viewControllers.first {
            root.navigationItem.titleView = titleImageView
            root.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
            root.navigationController?.navigationBar.isHidden = false
            root.navigationController?.navigationBar.isTranslucent = false
        }
        setupProfileButton()
        setupMessagesButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupMessagesButton() {
        self.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: messagesButton)
        let tapMessagesButton = UITapGestureRecognizer(target: self, action: #selector(self.showMessagesController))
        messagesButton.addGestureRecognizer(tapMessagesButton)
    }
    
    fileprivate func setupProfileButton() {
        self.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        let tapProfileButton = UITapGestureRecognizer(target: self, action: #selector(self.showProfileController))
        profileButton.addGestureRecognizer(tapProfileButton)
    }
    
    @objc func showMessagesController() {
        self.pushViewController(MessagesViewController(), animated: true)
    }
    
    @objc func showProfileController() {
        self.pushViewController(ProfileViewController(user: LocalStorage.shared.currentUserData), animated: true)
    }
    
}

extension CustomNavController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC is ProfileViewController {
            return PushPopAnimator(operation: operation, direction: .left)
        }
        if toVC is MessagesViewController {
            return PushPopAnimator(operation: operation, direction: .right)
        }
        return nil
    }
    
}

class PushPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let operation: UINavigationController.Operation
    
    let animationDirection: direction
    
    enum direction {
        case left
        case right
    }

    init(operation: UINavigationController.Operation, direction: direction) {
        self.operation = operation
        self.animationDirection = direction
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: .from)!
        let to   = transitionContext.viewController(forKey: .to)!
        
        let rightTransform = CGAffineTransform(translationX: transitionContext.containerView.bounds.size.width, y: 0)
        let leftTransform = CGAffineTransform(translationX: -transitionContext.containerView.bounds.size.width, y: 0)

        if operation == .push {
            to.view.transform = self.animationDirection == .right ? rightTransform : leftTransform
            transitionContext.containerView.addSubview(to.view)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                from.view.transform = self.animationDirection == .right ? leftTransform : rightTransform
                to.view.transform = .identity
            }, completion: { finished in
                from.view.transform = .identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else if operation == .pop {
            to.view.transform = self.animationDirection == .right ? leftTransform : rightTransform
            transitionContext.containerView.insertSubview(to.view, belowSubview: from.view)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                to.view.transform = .identity
                from.view.transform = self.animationDirection == .right ? rightTransform : leftTransform
            }, completion: { finished in
                from.view.transform = .identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
