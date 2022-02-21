//
//  AppDelegate.swift
//  RentaTeam Test
//
//  Created by Andrey Lobanov on 21.02.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = ImagesViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
