//
//  AppDelegate.swift
//  FraudSDK-iOS
//
//  Created by Ashish Gupta on 07/08/24.
//

import UIKit
import Sign3Intelligence

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("App Delegate")
        // Override point for customization after application launch.
        let options = Options.Builder()
            .setClientId("test_tenant_ios")
            .setClientSecret("secret-0ba302d5-6001-4462-a130-c413f87b689b")
            .setEnvironment(Environment.STAGING)
            .build()
        
        Sign3Intelligence.getInstance().initAsync(options: options){isInitialize in
            Utils.showInfologs(tags: "TAG_AppInstance", value: isInitialize.description)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

