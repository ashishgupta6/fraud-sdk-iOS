//
//  Sign3Intelligence.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 28/08/24.
//

import Foundation

public final class Sign3SDK {
    private static var sdk: Sign3SDK?
    private lazy var sign3IntelligenceInternal = Sign3IntelligenceInternal.getInstance()

    public static func getInstance() -> Sign3SDK {
        if sdk == nil {
            synchronized(Sign3SDK.self) {
                if sdk == nil {
                    sdk = Sign3SDK()
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

    public func getIntelligence(listener: IntelligenceResponseListener) {
        sign3IntelligenceInternal.getIntelligence(listener: listener)
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


