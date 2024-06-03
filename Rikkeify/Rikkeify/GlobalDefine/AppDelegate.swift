//
//  AppDelegate.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        
        setupWindow()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return false
        }
        
        guard let path = components.path else {
            return false
        }
        
        let trackId = path.replacingOccurrences(of: "/", with: "")
        
        let tabbarController = MainTabBarVC()
        window?.rootViewController = tabbarController
        
        let vc = TrackViewVC(trackId: trackId)
        vc.modalPresentationStyle = .overFullScreen
        tabbarController.present(vc, animated: true)
        
        window?.makeKeyAndVisible()
        
        return false
    }
}

extension AppDelegate {
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabbarController = MainTabBarVC()
        
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        //        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupBottomNavigation() -> UITabBarController {
        let homeNVC = UINavigationController()
        homeNVC.tabBarItem = .init(
            title: "Home",
            image: .init(named: "ic_home"),
            selectedImage: .init(named: "ic_home_activated")
        )
        
        let searchNVC = UINavigationController()
        searchNVC.tabBarItem = .init(
            title: "Search",
            image: .init(named: "ic_search"),
            selectedImage: .init(named: "ic_search_activated")
        )
        
        let yourLibraryNVC = UINavigationController()
        yourLibraryNVC.tabBarItem = .init(
            title: "Your Library",
            image: .init(named: "ic_your_library"),
            selectedImage: .init(named: "ic_your_library_activated")
        )
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .white
        tabBarController.setViewControllers([homeNVC, searchNVC, yourLibraryNVC], animated: true)
        
        return tabBarController
    }
}
