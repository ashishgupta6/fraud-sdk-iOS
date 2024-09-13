//
//  AppTampering.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/09/24.
//

import Foundation

class AppTampering{
    
    func isAppTampered() -> Bool {
        // Define known architecture constants
        let targetArchitectures: Set<Int32> = [
            CPU_ARCH_ABI64,  // 64-bit architectures (update with actual values)
            // Add other architectures if needed
        ]
        
        // Retrieve executable architectures
        guard let executableArchitectures = Bundle.main.executableArchitectures else {
            return true // Default to tampered if architecture info is missing
        }
        
        // Check if the target architecture is present
        let isArchitecturePresent = executableArchitectures.contains { architecture in
            let architectureInt = architecture.intValue
            return targetArchitectures.contains(Int32(architectureInt))
        }
        
        return !isArchitecturePresent
    }
}
