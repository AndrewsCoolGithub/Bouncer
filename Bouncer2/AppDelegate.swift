//
//  AppDelegate.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 4/23/22.
//

import UIKit
import Firebase
import FirebaseAppCheck
import CoreData
import BackgroundTasks
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let providerFactory = YourSimpleAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        
        

        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "bouncer.Bouncer2.updateRegions", using: nil) { task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil{
            print("🤩 received location update from background")
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
        }
       
        
        
        HapticsManager.shared.vibrate(for: .success)
        // Override point for customization after application launch.
        return true
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
       // Schedule a new refresh task.
       scheduleAppRefresh()

       // Create an operation that performs the main part of the background task.
//       let operation = RefreshAppContentsOperation()
       
       // Provide the background task with an expiration handler that cancels the operation.
       task.expirationHandler = {
//          operation.cancel()
       }

       // Inform the system that the background task is complete
       // when the operation completes.
//       operation.completionBlock = {
//          task.setTaskCompleted(success: !operation.isCancelled)
//       }

       // Start the operation.
//       operationQueue.addOperation(operation)
     }
    
    func scheduleAppRefresh() {
       let request = BGAppRefreshTaskRequest(identifier: "bouncer.Bouncer2.updateRegions")
       // Fetch no earlier than 15 minutes from now.
       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
       }
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
}
class YourSimpleAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}


extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didEnterRegion region: CLRegion
    ) {
        if region is CLCircularRegion {
            handleEvent(for: region)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didExitRegion region: CLRegion
    ) {
        if region is CLCircularRegion {
            handleEvent(for: region)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways{
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
//            UIBack
//            let events = BackgroundLocationManager.shared.getCloseEvents(<#T##location: CLLocation##CLLocation#>)
            
        }
    }
    

    
    func handleEvent(for region: CLRegion){
        print("got a region: \(region)")
    }
}
