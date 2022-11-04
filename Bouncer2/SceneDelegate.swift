//
//  SceneDelegate.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
//        try? Auth.auth().signOut()
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .greyColor()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        window?.overrideUserInterfaceStyle = .dark
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.poppinsMedium(size: .makeWidth(16.5))
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
//        Task{
//           try await AuthManager.shared.uploadUserData(User.defaultColors, field: .colors)
//            print("Succeeded")
//        }
        
//        let navCont = UINavigationController(rootViewController: EventSuite())
//        navCont.navigationBar.isHidden = true
//        self.window?.rootViewController = navCont
        
        if Auth.auth().currentUser != nil{
            User.setup()
            let navCont = UINavigationController(rootViewController: TabBarController())
            navCont.navigationBar.isHidden = true
            self.window?.rootViewController = navCont
            Location.shared.start { info in
                User.shared.locationInfo = info
            }
        }else{
            let navCont = UINavigationController(rootViewController: AccountSignUpEntry())
            navCont.interactivePopGestureRecognizer?.isEnabled = false
            navCont.navigationBar.isHidden = true
            self.window?.rootViewController = navCont
        }
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

