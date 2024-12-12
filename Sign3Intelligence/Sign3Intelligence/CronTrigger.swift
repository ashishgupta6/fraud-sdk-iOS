//
//  CronTrigger.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/12/24.
//

import Foundation

internal class CronTrigger {
    
    private var timer: DispatchSourceTimer?
    private let actionHandlerContinuousIntegrationImpl: ActionHandlerContinuousIntegrationImpl
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid

    
    init(actionHandlerContinuousIntegrationImpl: ActionHandlerContinuousIntegrationImpl) {
        self.actionHandlerContinuousIntegrationImpl = actionHandlerContinuousIntegrationImpl
    }

    func initTrigger() {
        startPeriodicTimer()
    }

    func buildActionContext() -> ActionContextSource {
        return ActionContextSource.CRON
    }

    func postTrigger() {
        startPeriodicTimer()
    }

    private func startPeriodicTimer() {
        // Cancel existing timer if active
        timer?.cancel()
        timer = nil
    
        // Start background task to allow the app to continue running in the background
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "CronTrigger") {
            // This block is called when the background task expires
            self.endBackgroundTask()
        }

        // Create a new timer
        let timeInSeconds = ConfigManager.config?.continuousIntegrationConfig.cronIntervalInSecs ?? Config.getDefault().continuousIntegrationConfig.cronIntervalInSecs
        let milliseconds = timeInSeconds * 1000
        let nanoseconds = milliseconds * 1000000
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .default))
        timer?.schedule(deadline: .now() + .nanoseconds(Int(nanoseconds)), repeating: .nanoseconds(Int(nanoseconds)))

        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.trigger()
        }
        
        timer?.resume()
    }

    private func trigger() {
        // Run the asynchronous task on the background queue using a Task
        DispatchQueue.global(qos: .userInitiated).async {
            Task {
                await self.actionHandlerContinuousIntegrationImpl.handle(source: self.buildActionContext())
            }
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTaskIdentifier != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            backgroundTaskIdentifier = .invalid
        }
    }

    deinit {
        timer?.cancel()
        timer = nil
    }
}
