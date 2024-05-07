//
//  AppDelegate.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        
        return true
    }
}

extension AppDelegate {
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TrackViewVC(viewModel: TrackViewVM(track: Track()))
        window?.makeKeyAndVisible()
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
