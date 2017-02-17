//
//  AppDelegate.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        StyleService.updateFromServer()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let host = url.host {
            // Handle authorization return from ShopTheRoe
            if (host == "strDidAuthorizeApp") {
                var activeAlert: UIAlertController
                
                let fields = url.fragment?.components(separatedBy: "&")
                
                var queryKeyPairs: [String: String] = [:]
                fields?.forEach { queryKeyPairs[$0.components(separatedBy: "=")[0]] = $0.components(separatedBy: "=")[1] }
                
                if let access_token = queryKeyPairs["access_token"] {
                    UserDefaults.standard.set(access_token, forKey: "strAccessToken")
                    activeAlert = UIAlertController(title: "Successfully authenticated with ShopTheRoe!", message: "", preferredStyle: .alert)
                    self.window?.rootViewController?.present(activeAlert, animated: true, completion: nil)
                    
                    let maxDisplayTime = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                        activeAlert.dismiss(animated: true, completion: nil)
                    })
                }

                if let error = getQueryStringParameter(url: url.absoluteString, param: "error") {
                    print(error)
                    
                    if let vc = self.window?.rootViewController as? STRViewController {
                        vc.authorizeButton.isHidden = false
                        vc.authorizeLabel.isHidden = false
                    }
                    
                    activeAlert = UIAlertController(title: "Failed to authenticate with ShopTheRoe.", message: "", preferredStyle: .alert)
                    self.window?.rootViewController?.present(activeAlert, animated: true, completion: nil)
                    
                    let maxDisplayTime = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                        activeAlert.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }

        return true
    }

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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    private func getQueryStringParameter(url: String?, param: String) -> String? {
        if let url = url, let urlComponents = URLComponents(string: url), let queryItems = (urlComponents.queryItems) {
            return queryItems.filter({ (item) in item.name == param }).first?.value!
        }
        return nil
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ConsultantAide")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

let ad = UIApplication.shared.delegate as! AppDelegate
let context = ad.persistentContainer.viewContext

