 //
//  AppDelegate.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import XCGLogger
import SVProgressHUD
import Fabric
import Crashlytics
 
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate ,GeTuiSdkDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])
        appearance()
        pushMessageRegister()
        umapp()
        registerMapSDK()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func pushMessageRegister() {
        //注册消息推送
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () in
            
#if true
            GeTuiSdk.startSdkWithAppId("d2YVUlrbRU6yF0PFQJfPkA", appKey: "yEIPB4YFxw64Ag9yJpaXT9", appSecret: "TMQWRB2KrG7QAipcBKGEyA", delegate: self)
#endif
            
            let notifySettings = UIUserNotificationSettings.init(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notifySettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
        })
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var token = deviceToken.description
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "")
        token = token.stringByReplacingOccurrencesOfString("<", withString: "")
        token = token.stringByReplacingOccurrencesOfString(">", withString: "")
        
        XCGLogger.debug("\(token)")
#if true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () in
            GeTuiSdk.registerDeviceToken(token)
        })
#endif
        CurrentUserHelper.shared.deviceToken = token
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
    }
    
    private func appearance() {
        let navigationBar:UINavigationBar = UINavigationBar.appearance() as UINavigationBar;
        navigationBar.setBackgroundImage(UIImage(named: "head_bg"), forBarMetrics: .Default)
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()];
        navigationBar.translucent = false;
        navigationBar.tintColor = UIColor.whiteColor();
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics:.Default);
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        UITableView.appearance().backgroundColor = AppConst.Color.C6;
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        //        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
    }

    private func umapp(){
        
        UMAnalyticsConfig.sharedInstance().appKey = AppConst.UMAppkey
        UMAnalyticsConfig.sharedInstance().channelId = ""
        MobClick.startWithConfigure(UMAnalyticsConfig.sharedInstance())
        //version标识
        let version: String? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
        MobClick.setAppVersion(version)
        //日志加密设置
        MobClick.setEncryptEnabled(true)
        //使用集成测试服务
        MobClick.setLogEnabled(true)
        //Crash
        MobClick.setCrashReportEnabled(false)
    }
    private func registerMapSDK() {
        var key = ""
        if let id = NSBundle.mainBundle().bundleIdentifier {
            if id == "com.yundian.enterprise.trip" {
                key = "11feec2b7ad127ae156d72aa08f2342e"
            } else if id == "com.yundian.trip" {
                //                    key = "50bb1e806f1d2c1a797e6e789563e334"
                key = "7c6f2b0d4d35fce64803e99efb2fbd55"
            }
        }
        AMapServices.sharedServices().apiKey = key
    }
}

