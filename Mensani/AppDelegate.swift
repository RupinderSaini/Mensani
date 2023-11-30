//
//  AppDelegate.swift
//  Mensani
//
//  Created by apple on 03/05/23.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Override point for customization after application launch.
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs token retrieved: \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
  var window: UIWindow?


}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Userinfo2 \(notification.request.content.userInfo)")
       
        completionHandler([[.alert, .sound]])
    }
  
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
//        print("Userinfo1 \(response.notification.request.content.userInfo)")
//        UserDefaults.standard.set("1", forKey: Constant.notificationReceived)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let presentViewController = storyBoard.instantiateViewController(withIdentifier: "noti") as! NotificationController
//                
////            presentViewController.yourDict = userInfo //pass userInfo data to viewController
//            self.window?.rootViewController = presentViewController
//            presentViewController.present(presentViewController, animated: true, completion: nil)
//
//        completionHandler()
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                        -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("userInfo receibver \(userInfo)")
            UserDefaults.standard.set("1", forKey: Constant.notificationReceived)
            print("Message ID: \(messageID)")
            guard
                let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
                let alert = aps["alert"] as? NSDictionary,
                let body = alert["body"] as? String,
                let title = alert["title"] as? String
            else {
                
                
                // handle any error here
                return
            }
            
            
        }
        
        
        // Print full message.
        //  print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}

