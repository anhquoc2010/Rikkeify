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
        window?.rootViewController = TrackViewVC(viewModel: TrackViewVM(track: Track(thumbnail: "ic_app", name: "Rikkeify", author: "Rikkei", lyrics: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", playlist: "Rikkei List")))
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
