//
//  AppDelegate.swift
//  tutorial-one
//
//  Created by Samuel Heavner on 5/2/15.
//  Copyright (c) 2015 Samuel Heavner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var mapsKey = ""
        var analyticsId = ""
        var apiUrl = ""
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            mapsKey = dict["GoogleMapsAPIKey"] as! String
            analyticsId = dict["AnalyticsId"] as! String
            apiUrl = dict["MbtApiUrl"] as! String
        }else{
            debugPrint("Config.plist not found! Use /exmaple.Config.plist to make a Config.plist with proper values.")
        }
        if apiUrl == "" {
            debugPrint("API url is not set! Set it in /Config.plist")
        }
        if analyticsId == "" {
            debugPrint("Analytics Id not set, this isn't really a big deal. Set it in /Config.plist")
        }
        if mapsKey == "" {
            debugPrint("Google Maps Key not set! Set it in /Config.plist")
        }
        
        DataManager.setApiUrl(apiUrl)
        GMSServices.provideAPIKey(mapsKey)
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        GAI.sharedInstance().trackerWithTrackingId(analyticsId)
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


}

