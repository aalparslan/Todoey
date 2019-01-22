//
//  AppDelegate.swift
//  Todoey
//
//  Created by Guest on 1/20/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ =  try Realm()
        } catch {
            print("Error initialising new realm \(error)")
        }

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // #TO HANDLE INTERRAPTIONS
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //what happens when your app dissappear for ex: home button pressed
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}




