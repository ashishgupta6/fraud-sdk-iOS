//
//  RemoteAccessDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 27/11/24.
//

import Foundation
import UIKit

class RemoteAccessDetector {
    
    private let TAG = "RemoteAccessDetector"
    
    internal func isScreenBeingMirrored() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                var isMirrored: Bool = false
                
                let screen = await UIScreen.main
                isMirrored = await screen.isCaptured
                
                return isMirrored
            }
        )
    }
}
