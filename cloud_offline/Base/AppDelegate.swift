//
//  AppDelegate.swift
//  cloud_offline
//
//  Created by Macbook on 21/06/2021.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        GIDConfiguration.init(clientID: "1046039274489-k6iv3mbb8tkebu1f2280e2ftsj54nvgd.apps.googleusercontent.com")
//        GIDSignIn.sharedInstance().clientID = "1046039274489-k6iv3mbb8tkebu1f2280e2ftsj54nvgd.apps.googleusercontent.com"
//        window = UIWindow()
//        window?.makeKeyAndVisible()
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "LocalViewController") as! LocalViewController
//        window?.rootViewController = vc
        setupIntialRecent()
        return true
    }
    func setupIntialRecent(){
        if UserDefaults.standard.integer(forKey: "recentAudio") == 0 {
            let audio = RecentAudio()
            RealmService.shared.add(audio)
            UserDefaults.standard.set(1, forKey: "recentAudio")
            print("audio nil")
        }
        if UserDefaults.standard.integer(forKey: "recentVideo") == 0 {
            let video = RecentVideo()
            RealmService.shared.add(video)
            UserDefaults.standard.set(1, forKey: "recentVideo")
            print("video nil")
        }
        
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
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
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//    }
        
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
//        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
//        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//    }

}

