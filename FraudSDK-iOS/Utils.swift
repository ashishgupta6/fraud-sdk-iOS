//
//  Utils.swift
//  FraudSDK-iOS
//
//  Created by Ashish Gupta on 29/08/24.
//

import Foundation


class Utils{
    
    static func checkThread(){
        let thread = Thread.current
        let threadId = thread.value(forKeyPath: "private.seqNum") as? Int ?? 0
        
        print("Thread ID: \(threadId)")
        print("Is Main Thread: \(thread.isMainThread)")
    }
}
