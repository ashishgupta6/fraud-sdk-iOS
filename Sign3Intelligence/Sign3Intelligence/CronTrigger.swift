//
//  CronTrigger.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/12/24.
//

import Foundation

internal class CronTrigger {
    
    private let TAG = "CronTrigger"
    private var timer: DispatchSourceTimer?
    private let actionHandlerContinuousIntegrationImpl: ActionHandlerContinuousIntegrationImpl
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    private var count = 0
    
    init(actionHandlerContinuousIntegrationImpl: ActionHandlerContinuousIntegrationImpl) {
        self.actionHandlerContinuousIntegrationImpl = actionHandlerContinuousIntegrationImpl
    }
    
    func initTrigger() {
        startPeriodicTimer()
    }
    
    func buildActionContext() -> ActionContextSource {
        return ActionContextSource.CRON
    }
    
    private func startPeriodicTimer() {
        /// Cancel existing timer if active
        timer?.cancel()
        timer = nil
        
        /// Start background task to allow the app to continue running in the background
        DispatchQueue.global(qos: .background).async {
            self.startBackgroundTask()
        }
        
        /// Create a new timer
        let timeInSeconds = ConfigManager.config?.continuousIntegrationConfig.cronIntervalInSecs ?? Config.getDefault().continuousIntegrationConfig.cronIntervalInSecs
        let milliseconds = timeInSeconds * 1000
        let nanoseconds = milliseconds * 1000000
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .userInitiated))
        timer?.schedule(deadline: .now() + .nanoseconds(Int(nanoseconds)), repeating: .nanoseconds(Int(nanoseconds)))
        
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            Log.i(TAG, "Cron Trigger")
            self.trigger()
        }
        
        timer?.resume()
    }
    
    private func startBackgroundTask() {
        Log.i(TAG, "Background Task Started")
        count = count + 1
        Log.i(TAG, count.description)
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "\(TAG)\(count)") { [weak self] in
            guard let self = self else { return }
            self.endBackgroundTask()
            self.startBackgroundTask() // Restart background task
        }
    }
    
    private func trigger() {
        DispatchQueue.global(qos: .userInitiated).async {
            Task {
                await self.actionHandlerContinuousIntegrationImpl.handle(source: self.buildActionContext())
            }
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTaskIdentifier != .invalid {
            Log.i(TAG, "End Background Task")
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            backgroundTaskIdentifier = .invalid
        }
    }
    
    deinit {
        timer?.cancel()
        timer = nil
        endBackgroundTask()
    }
}
