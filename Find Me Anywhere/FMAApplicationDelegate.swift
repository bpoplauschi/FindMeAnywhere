//
//  FMAApplicationDelegate.swift
//  Find Me Anywhere
//
//  Created by Bogdan Poplauschi on 22/05/2017.
//  Copyright © 2017 Find Me Anywhere. All rights reserved.
//

import UIKit

@UIApplicationMain
class FMAApplicationDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let alertController = UIAlertController(title: notification.alertTitle, message: notification.alertBody, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in }
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

