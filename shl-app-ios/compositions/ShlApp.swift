//
//  HockeyPalApp.swift
//  HockeyPal
//
//  Created by Pål Forsberg on 2021-01-08.
//

import SwiftUI

@main
struct ShlApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.rounded(ofSize: 35, weight: .bold)]
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var settings = Settings()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.applicationIconBadgeNumber = 0
        return true
    }
    
    /**
     1: registerForPushNotifications and request user permission
     2: getNotificationSettings and register for remote notifications
     3: didRegisterForRemoteNotificationsWithDeviceToken or didFailToRegisterForRemoteNotificationsWithError handle token or error
     */
    static func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("[APP] Permission granted: \(granted)")
            guard granted else { return }
            AppDelegate.getNotificationSettings()
        }
    }
    
    static func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("[APP] Device Token: \(token)")
        AppDelegate.settings.apnToken = token
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("[APP] Failed to register: \(error.localizedDescription)")
    }
}
