//
//  AppDelegate.swift
//  Aqar55
//
//  Created by Callsoft on 27/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManager
import KYDrawerController
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{
    var window: UIWindow?
    
    var countryArray:NSMutableArray = NSMutableArray()
    
    var drawerController = KYDrawerController.init(drawerDirection: .left, drawerWidth: 275)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool{
        
        
        Thread.sleep(forTimeInterval: 1.0)
        
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey(kGoogleApiKey)
        GMSPlacesClient.provideAPIKey("AIzaSyBML-mOK3vjg2uK1zSKPbLuXy1_4csqq50")
        IQKeyboardManager.shared().isEnabled = true
        drawerController.screenEdgePanGestureEnabled = false
        
        
        if let isLogin = UserDefaults.standard.value(forKey: "ISLOGIN") as? Bool{
            
            if isLogin == true{
                
                 initHome()
            }
        }else{
                        
            if UserDefaults.standard.bool(forKey: "NotFirstTime"){
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SignupOptionController") as! SignupOptionController
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            }
            else{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TakeTourController") as! TakeTourController
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            }
            
        }
        
        self.getCountryList()
        
        let simulaterToken = "b1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        
        UserDefaults.standard.set(simulaterToken as String, forKey: "DeviceToken")
        
        registerForRemoteNotification()
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
        } else {}
        
        
        return true
    }
    
    func initHome() -> AppDelegate
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        
        let nav = UINavigationController(rootViewController: menuVC)
        nav.isNavigationBarHidden = true
        
        let navigationController = UINavigationController(rootViewController: drawerController)
       
        let nav1 = UINavigationController(rootViewController: homeVC)
        nav1.isNavigationBarHidden = true
        
        
        self.drawerController.mainViewController = nav1
        self.drawerController.drawerViewController = nav
        navigationController.isNavigationBarHidden = true
        
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return UIApplication.shared.delegate as! AppDelegate
        
    }
    
    //MARK:- Notifications delegates
    
    func registerForRemoteNotification() {
        
        if #available(iOS 10, *) {
            
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        }
        else if #available(iOS 9, *) {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            
            UIApplication.shared.registerForRemoteNotifications()
            
        }
    }
    
    func setupPushNotifications()
    {
        
        if #available(iOS 10.0, *){
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "DeviceTokenUpdated"), object: nil)
                        
                    }
                    
                    print("unsuccesfull")
                }
            })
        }
            
        else{
            
            let userNotificationTypes:UIUserNotificationType = ([UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound])
            
            if UIApplication.shared.responds(to: #selector(getter: UIApplication.isRegisteredForRemoteNotifications)){
                
                let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
                
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
                
            }
            else {
                
            }
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if application.isRegisteredForRemoteNotifications == true{
            
            application.registerForRemoteNotifications()
            
        }else{
            
            print("application.isRegisteredForRemoteNotifications() ====== \(application.isRegisteredForRemoteNotifications)")
            
            let simulaterToken = "b1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            
            UserDefaults.standard.set(simulaterToken as String, forKey: "DeviceToken")
            
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //let characterSet: NSCharacterSet = NSCharacterSet( charactersIn: "<>" )
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        UserDefaults.standard.set(deviceTokenString as String, forKey: "DeviceToken")
        
        NSLog("Device Token : %@", deviceTokenString)
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        let simulaterToken = "b1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        UserDefaults.standard.set(simulaterToken, forKey: "DeviceToken")
        print(error, terminator: "")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("hello")
        //  print("Recived: \(userInfo)")
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        let pushForForegroundDict = notification.request.content.userInfo as NSDictionary
        
        print(pushForForegroundDict)
        
        let type = pushForForegroundDict.object(forKey: "type") as? String ?? ""
        
        if type == "chat"{
            
            if CommonClass.sharedInstance.chatScreenIsOpen == false{
                
                completionHandler(.alert)
            }
        }
        else{
            
            completionHandler(.alert)
        }
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        
        print(userInfo)
        
        let type = userInfo.object(forKey: "type") as? String ?? ""
        
        if type == "chat"{
            
            let data = NSKeyedArchiver.archivedData(withRootObject: userInfo)
            UserDefaults.standard.set(data, forKey: "MsgData")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForRedirectionOnChat"), object: nil)
            
        }
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
     
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
    }


    func setCountryList(info:NSDictionary) {
        
        let countries: NSDictionary = info.object(forKey: "countries") as! NSDictionary
        let arr_Country: NSArray = countries.object(forKey: "country") as! NSArray
        let arr:NSMutableArray = NSMutableArray()
        
        for i in 0..<arr_Country.count {
            
            let dict:NSDictionary = arr_Country[i] as! NSDictionary
            
            let dictCode = dict.object(forKey: "code") as? NSDictionary
            let text: String = (dictCode?.object(forKey: "text") as? String)!
            let dialing_code: String = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let country_name: String = (dict.object(forKey: "name") as? String)!
            let country_code: String = (dict.object(forKey: "iso") as? String)!
            let country_dailing_code: String = dialing_code
            let info:NSDictionary = ["country_name":country_name,"country_code":country_code,"country_dailing_code":country_dailing_code]
            arr.add(info)
        }
        let descriptor: NSSortDescriptor =  NSSortDescriptor(key: "country_name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let sortedResults: NSArray = (arr.sortedArray(using: [descriptor]) as? NSArray)!
        self.countryArray = NSMutableArray(array: sortedResults)
        print(self.countryArray)
        
    }
    
    func getCountryList(){
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            let list:NSDictionary = CommonMethod.getDictionaryFromXMLFile("country_list_c2call", fileExtension: "xml") as NSDictionary
            
            self.setCountryList(info:list)
        })
    }
    
}

