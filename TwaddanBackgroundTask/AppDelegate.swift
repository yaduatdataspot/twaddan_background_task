//
//  AppDelegate.swift
//  TwaddanBackgroundTask
//
//  Created by Data Spot on 13/11/24.
//

import UIKit
import BackgroundTasks


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let taskId = "com.yadu.twaddan.backgroundTask1"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil ){task in
            guard let task = task as? BGProcessingTask else {return}
            self.handleTask(task: task)
        }
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        print("task run \(count) times")
        requestPermission()
        return true
    }
    
    
    private func handleTask(task : BGProcessingTask){
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        UserDefaults.standard.set(count + 1, forKey: "task_run_count")
        task.expirationHandler = {
            
        }
        task.setTaskCompleted(success: true)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func requestPermission() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    print("Permission granted for local notifications")
                } else {
                    if let error = error {
                        print("Error requesting permission: \(error.localizedDescription)")
                    } else {
                        print("Permission denied for local notifications")
                    }
                }
            }
        }
}


