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
    private lazy var sign3IntelligenceInternal = Sign3IntelligenceInternal.getInstance()

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

    public func initAsync(options: Options, completion: @escaping (Bool) -> Void) {
        sign3IntelligenceInternal.initAsync(options, completion)
    }

    public func updateOptions(updateOption: UpdateOption) {
        sign3IntelligenceInternal.updateOption(updateOption)
    }

    public func getIntelligence(completion: @escaping ([String: Any]) -> Void) {
        sign3IntelligenceInternal.getIntelligence { intelligenceData in
            // Call the completion handler with the received intelligence data
            completion(intelligenceData)
        }
    }
    
    public func getSessionId() -> String {
        return sign3IntelligenceInternal.options?.sessionId ?? ""
    }
}

private func synchronized(_ lock: Any, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

