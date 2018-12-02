//
//  AppDelegate.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let eventKitAccess = BillEventKitSupport.support.accessAuthed
        
        let locationStatus = CLLocationManager.authorizationStatus()
        let locationAccess = locationStatus == .authorizedAlways ||
            locationStatus == .authorizedWhenInUse
        
        if !(eventKitAccess && locationAccess) {
            let rootViewController = AccessViewController()
            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
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
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let scheme = url.scheme,let query = url.query {
            if scheme == "billx"{
                let params = query.components(separatedBy: "&")
                let money = Double(params.first!.components(separatedBy: "=").last ?? "0.0")!
                var usage = ""
                var note = ""
                var date = ""
                var year = Date().year
                var month = Date().month
                var day = Date().day
                
                if params.count == 4 {
                    usage = params[1].components(separatedBy: "=").last?.urlDecoded() ?? ""
                    note = params[2].components(separatedBy: "=").last?.urlDecoded() ?? ""
                    date = params[3]
                }
                else if params.count == 2 {
                    date = params[1]
                }
                if date != "" {
                    let dateS = date.components(separatedBy: "-")
                    if dateS.count == 3 {
                        year = Int(dateS.first!) ?? Date().year
                        month = Int(dateS[1]) ?? Date().month
                        day = Int(dateS[2]) ?? Date().day
                    }
                }
                
                let vc = self.currentViewController()
                if !vc.isKind(of: EditBillViewController.self) {
                    let editDate = Calendar.current.dateWith(year: year, month: month, day: day)
                    
                    let edit = EditBillViewController.init(with: nil ,date: editDate)
                    edit.transitioningDelegate  = vc as? UIViewControllerTransitioningDelegate
                    edit.modalPresentationStyle = .custom
                    edit.setup(for: money, usage: usage, note: note)
                    vc.present(edit, animated: true, completion: nil)
                }
            }
        }
        return true
    }
    
}


extension AppDelegate {
    
    fileprivate func currentViewController() -> UIViewController {
        
        let root = self.window!.rootViewController!
        return self.getCurrentViewController(from: root)
    }
    
    func getCurrentViewController(from vc : UIViewController) -> UIViewController {
    
        var rootVC = vc
        var result : UIViewController
        
        if let presendVC = rootVC.presentedViewController {
            rootVC = self.getCurrentViewController(from: presendVC)
        }
        if rootVC.isKind(of: UITabBarController.self) {
            let tabbarVC = rootVC as! UITabBarController
            result = self.getCurrentViewController(from: tabbarVC.selectedViewController!)
        } else if rootVC.isKind(of: UINavigationController.self) {
            let naviVC = rootVC as! UINavigationController
            result = self.getCurrentViewController(from: naviVC.visibleViewController!)
        } else {
            result = rootVC
        }
        return result
    }
}
