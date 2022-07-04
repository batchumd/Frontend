//
//  SceneDelegate.swift
//  Batch
//
//  Created by Kevin Shiflett on 12/4/21.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // If this scene's self.window is nil then set a new UIWindow object to it.
        self.window = self.window ?? UIWindow()

        // Set this scene's window's background color.
        self.window!.backgroundColor = UIColor.clear

        // Make this scene's window be visible.
        self.window!.makeKeyAndVisible()
        
        Switcher.updateRootVC()
        
        guard scene is UIWindowScene else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    


}


class Switcher {
    
    static func updateRootVC(){
        
        let navController = UINavigationController()
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.view.backgroundColor = .white
        
        let status = Auth.auth().currentUser != nil

        if (status == true) {
            navController.viewControllers = [MainViewController()]
        } else {
           navController.viewControllers = [SignedOutViewController()]
        }
        
        let window = UIApplication.shared.keywindow
        guard let uWindow = window else { return }

        uWindow.rootViewController = navController
        UIView.transition(with: uWindow, duration: 0.3, options: [.transitionCrossDissolve], animations: {}, completion: nil)
    }
    
}
