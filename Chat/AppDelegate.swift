//
//  AppDelegate.swift
//  Chat
//
//  Created by Niid tech on 03/03/18.
//  Copyright © 2018 NiidTechnology. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Messages

var isFromNotification : Bool = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self as? MessagingDelegate
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
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
        
        FirebaseApp.configure()

        
        let token = Messaging.messaging().fcmToken
//        // use the following line for Firebase < 4.0.0
//        //let token = FIRInstanceID.instanceID().token()
//        print("FCM token: \(token ?? "")")
        
        
        
        
        // [END register_for_notifications]

///*6s
        //Login Account
         Auth.auth().signIn(withEmail: "akshayp@niidtech.com", password: "123456") { (user, error) in
            print("error :",error as Any)
            print("user :", user?.email as Any)
            print("user :", user?.displayName as Any)
            
            
            
            
            // ...
        } //*/

/*5s
        Auth.auth().signIn(withEmail: "patilakshays1994@gmail.com", password: "123456") { (user, error) in
           print("error :",error as Any)
           print("user :", user?.email as Any)
           print("user :", user?.displayName as Any)
//            // ...
        } */
        
        let  image  = UIImage.init(named: "profile pic")
//        User.registerUser(withName: "Akshay", email: "patilakshays1994@gmail.com", password: "123456", profilePic: image!, token: token!) { [weak weakSelf = self] (status) in

//            User.registerUser(withName: "Aksh", email: "akshayp@niidtech.com", password: "123456", profilePic: image!, token: token!) { [weak weakSelf = self] (status) in
//            DispatchQueue.main.async {
//                //                    weakSelf?.showLoading(state: false)
//                //                    for item in self.inputFields {
//                //                        item.text = ""
//                //                    }
//                if status == true {
//                    //                    UserDefaults.standard.set(true, forKey: "isSession")
//                    //                    self .performSegue(withIdentifier: "Login", sender: self)
//                    //                        weakSelf?.pushTomainView()
//                    //                        weakSelf?.profilePicView.image = UIImage.init(named: "profile pic")
//                } else {
//                    //                        for item in (weakSelf?.waringLabels)! {
//                    //                            item.isHidden = false
//                    //                        }
//                }
//            }
//        }
        
//        User.logOutUser { (status) in
//            if status == true {
//            }
//        }
        
        
        return true
    }
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if let refreshedToken = InstanceID.instanceID().token() {
            var token = refreshedToken
            token = (token.replacingOccurrences(of: "<", with: "") as NSString) as String
            token = (token.replacingOccurrences(of: ">", with: "") as NSString) as String
            token = (token.replacingOccurrences(of: " ", with: "") as NSString) as String
            print("InstanceID token: \(token)")
        }
    
//        print("APNs token retrieved: \(deviceToken.description)")
//        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        var token = NSString(format: "%@", deviceToken as CVarArg)
//        token = token.replacingOccurrences(of: "<", with: "") as NSString
//        token = token.replacingOccurrences(of: ">", with: "") as NSString
//        token = token.replacingOccurrences(of: " ", with: "") as NSString
//        print("APNs token retrieved:", token)
    
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        UIApplication.shared.applicationIconBadgeNumber = 0
        let state = UIApplication.shared.applicationState
        if state == .background || state == .active || state == .inactive {
            print("App in Background")
            
        }else{
            isFromNotification = true
        }
        
        /*
        let reminderListVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListVC") as! ListVC
        let navigationController = UINavigationController(rootViewController: reminderListVC)
        self.window?.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
        
        let editProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        navigationController.pushViewController(editProfileVC, animated: true)
        */

        completionHandler()
    }

//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }


   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //logout alert
    
}

/*
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
*/

