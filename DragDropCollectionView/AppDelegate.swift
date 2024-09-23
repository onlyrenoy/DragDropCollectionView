//
//  AppDelegate.swift
//  DragDropCollectionView
//
//  Created by Renoy Chowdhury on 23/09/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let home = UINavigationController(rootViewController: DragDropViewController())
        home.navigationBar.tintColor = .white
        self.window?.rootViewController = home
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

