//
//  OsBuildRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


internal struct OsBuildRawData: Codable {
    let kernalVersion: String
    let kernalOsVersion: String
    let kernalOsRelease: String
    let kernalOSType: String
    let iOSVersion: String
    let securityProvidersData: [String]
    
    enum CodingKeys: String, CodingKey {
        case kernalVersion = "a"
        case kernalOsVersion = "b"
        case kernalOsRelease = "c"
        case kernalOSType = "d"
        case iOSVersion = "e"
        case securityProvidersData = "f"
    }
}
