//
//  AppDelegate.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: Registering Launch Handlers for Tasks
        let backgroundTaskId = AppSetting.shared.infoForKey(AppSettingConstant.Key.backgroundTaskId.value)
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskId, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        return true
    }

    // Fetch the latest price index from server.
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleFetchRefresh()
        NetworkService.instance.request(target: MainService.getCurrentPrice, model: CurrentPriceResponse.self) { result in
            switch result {
            case .success(let response):
                let dateTime = response.time.updatedISO
                let value = response.bpi.usd.rateFloat
                let longitude = String((LocationService.shared.getLongitude()))
                let latitude = String(LocationService.shared.getLatitude())
                let priceIndex = PriceIndex(dateTime: dateTime, value: value, longitude: longitude, latitude: latitude)
                if let priceIndexData = try? DataService.shared.load(key: PriceIndex.structName) {
                    do {
                        var listPriceIndex = try JSONDecoder().decode([PriceIndex].self, from: priceIndexData)
                        listPriceIndex.append(priceIndex)
                        let sortedList = listPriceIndex.sorted { $0.dateTime.toDate().compare($1.dateTime.toDate()) == .orderedDescending }
                        try DataService.shared.save(data: sortedList, key: PriceIndex.structName)
                    } catch {
                        debugPrint(error)
                    }
                }
            case .failure(let error):
                if let errorResponse = error as? ErrorResponse {
                    debugPrint(errorResponse)
                } else {
                    debugPrint(ErrorResponse.generalError())
                }
            }
            task.setTaskCompleted(success: true)
        }
        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
            task.setTaskCompleted(success: false)
        }
    }
    
    // MARK: - Scheduling Tasks
    func scheduleFetchRefresh() {
        let backgroundTaskId = AppSetting.shared.infoForKey(AppSettingConstant.Key.backgroundTaskId.value)
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskId)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) // Fetch no earlier than 60 minutes from now
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            debugPrint("Could not schedule app refresh: \(error)")
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

