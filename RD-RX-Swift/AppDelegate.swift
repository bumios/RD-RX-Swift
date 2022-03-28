//
//  AppDelegate.swift
//  RD-RX-Swift
//
//  Created by Duy Tran N. VN.Danang on 3/23/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        if let window = window {
            window.rootViewController = HomeViewController()
            window.backgroundColor = .systemGreen
            window.makeKeyAndVisible()
        }

        return true
    }
}
