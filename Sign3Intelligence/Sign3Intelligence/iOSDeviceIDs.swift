//
//  iOSDeviceIDs.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


internal struct iOSDeviceIDs: Codable {
    let iOSDeviceId: String
    let cloudId: String
    let applicationId: String
    let advertisingID: String
    
    enum CodingKeys: String, CodingKey {
        case iOSDeviceId = "a"
        case cloudId = "b"
        case applicationId = "c"
        case advertisingID = "d"
    }
}
