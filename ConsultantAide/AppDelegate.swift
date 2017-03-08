//
//  AppDelegate.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/2/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit
import CoreData
import GSMessages

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Rollbar.initWithAccessToken("270145b3cd72483299c6495dedcd0aeb")
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
                    self.window?.rootViewController?.showMessage("You are logged into ShopTheRoe!", type: .success, options: [
                        .position(.bottom)
                        ])
                    
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
        self.saveMainContext()
    }
    
    private func getQueryStringParameter(url: String?, param: String) -> String? {
        if let url = url, let urlComponents = URLComponents(string: url), let queryItems = (urlComponents.queryItems) {
            return queryItems.filter({ (item) in item.name == param }).first?.value!
        }
        return nil
    }

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cadiridris.coreDataTemplate" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "ConsultantAide", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let supportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let url = supportDirectory.appendingPathComponent("ConsultantAide.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if !(FileManager.default.fileExists(atPath: supportDirectory.path)) {
            print("[Debug] Could not find \(supportDirectory). Will create now.")
            
            do {
                try FileManager.default.createDirectory(at: supportDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                Rollbar.error(withMessage: "Could not create the necessary ApplicationSupport directory for the SQLite database.")
                abort()
            }
        }
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.mattorahood.ConsultantAide", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()
    
    lazy var masterManagedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    func saveMasterContext() {
        masterManagedObjectContext.perform {
            do {
                try self.masterManagedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.masterManagedObjectContext
        return context
    }()
    
    func saveMainContext() {
        mainManagedObjectContext.perform {
            do {
                try self.mainManagedObjectContext.save()
                self.saveMasterContext()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    lazy var temporaryWorkerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainManagedObjectContext
        return context
    }()
    
    func saveWorkerContext(context: NSManagedObjectContext) {
        do {
            try context.save()
            self.saveMainContext()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}

let ad = UIApplication.shared.delegate as! AppDelegate
