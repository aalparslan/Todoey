//
//  AppDelegate.swift
//  Todoey
//
//  Created by Guest on 1/20/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //FIRST THING HAPPENS BEFORE EVERYTHING ELSE!
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // #TO HANDLE INTERRAPTIONS
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("appdidenterbackground")
        //what happens when your app dissappear for ex: home button pressed
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("@@@@@p")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

