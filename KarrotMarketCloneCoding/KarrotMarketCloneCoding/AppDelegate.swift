//
//  AppDelegate.swift
//  KarrotMarketCloneCoding
//
//  Created by EHDOMB on 2022/07/11.
//

import UIKit
import FirebaseCore
import Alamofire
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 파이어 베이스 초기 설정
        FirebaseApp.configure()
        
        // 클라우드 메세징 대리자 설정
        Messaging.messaging().delegate = self
        
        // push notification 대리자 설정
        UNUserNotificationCenter.current().delegate = self
        
        // push notification option 설정
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, error in
            guard error == nil else {
                return
            }
            
            if isGranted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: UISceneSession Lifecycle

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // .banner, .list: iOS 14+부터 사용가능
        completionHandler([.badge, .sound, .banner, .list])
    }
}

// FCM delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        UserDefaults.standard.setValue(fcmToken, forKey: UserDefaultsKey.fcmToken)
    }
}
