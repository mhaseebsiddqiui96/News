//
//  AppDelegate.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/3/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: TopStoriesListRouter.createModule())
        window?.makeKeyAndVisible()
        return true
    }


}

