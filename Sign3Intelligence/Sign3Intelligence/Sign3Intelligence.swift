//
//  Sign3Intelligence.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 28/08/24.
//

import Foundation

import os.log
import BackgroundTasks

public final class Sign3Intelligence {

    private static var sdk: Sign3Intelligence?
    private var sign3IntelligenceInternal: Sign3IntelligenceInternal?

    public static func getInstance() -> Sign3Intelligence {
        if sdk == nil {
            synchronized(Sign3Intelligence.self) {
                if sdk == nil {
                    sdk = Sign3Intelligence()
                }
            }
        }
        return sdk!
    }

    public func initAsync() {
        sign3IntelligenceInternal = Sign3IntelligenceInternal.getInstance()
        sign3IntelligenceInternal?.initAsync()
        print("Init Async")
    }

    public func updateOptions() {

    }

    public func getIntelligence() {
        sign3IntelligenceInternal?.getIntelligence()
    }
    

    public func getSessionId() -> String {
        return UUID().uuidString
    }
}

private func synchronized(_ lock: Any, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

