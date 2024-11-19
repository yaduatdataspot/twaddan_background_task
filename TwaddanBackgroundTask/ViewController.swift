//
//  ViewController.swift
//  TwaddanBackgroundTask
//
//  Created by Data Spot on 13/11/24.
//

import UIKit
import BackgroundTasks
class ViewController: UIViewController {
    let taskId = "com.yadu.twaddan.backgroundTask1"
    var idleTimer: Timer?
    let idleTimeInterval: TimeInterval = 180
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.scheduleNotification()
        // Do any additional setup after loading the view.
    }
    
    @objc func appDidEnterBackground() {
        idleTimer?.invalidate()
        
        
               print("Scheduled background task from ViewController.")
        schedule()

       }
    
    @objc func appWillEnterForeground() {
        
        endBackgroundTask()
    }
    
    private func schedule(){
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskId)
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            print("\(requests.count) task pending")
            guard requests.isEmpty else{
                return
            }
        }
        do{
            let newTask = BGProcessingTaskRequest(identifier: taskId)
            newTask.requiresExternalPower = false
            newTask.requiresNetworkConnectivity = true
            newTask.earliestBeginDate = Date().addingTimeInterval(86400 * 3)
            try BGTaskScheduler.shared.submit(newTask)
            print("task scheduled")
            startTask()
        }
        catch{
            print("failed to schedule \(error)")
        }
    }
    
    
    func startTask() {

        DispatchQueue.global().asyncAfter(deadline: .now() + idleTimeInterval) { // 3 minutes
                    print("Background task performed after 3 minutes")
                Task{
                    self.scheduleNotification()
//                   await self.lossMaking()
                  
                }
                    
        }
         registerBackgroundTask()
     }
    
    func scheduleNotification() {
              // Create notification content
              let content = UNMutableNotificationContent()
              content.title = "Local Notification"
              content.body = "This is a local notification example."
              content.sound = .default

              // Create a trigger for the notification (every 2 minutes)
              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

              // Create a request with a unique identifier
              let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)

              // Add the request to the notification center
              UNUserNotificationCenter.current().add(request) { error in
                  if let error = error {
                      print("Error scheduling notification: \(error.localizedDescription)")
                  }
              }
          }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }

    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }


}

