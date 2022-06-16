//
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit

class HistoryViewController: ViewControllerWithHeader {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader(title: "History")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem.init(title: "Friends", image: UIImage(named: "friends"), tag: 3)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Gilroy-ExtraBold", size: 11)!], for: .normal)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
