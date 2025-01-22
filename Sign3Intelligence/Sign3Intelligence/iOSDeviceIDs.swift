//
//  iOSDeviceIDs.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


//internal struct iOSDeviceIDs: Codable {
//    let iOSDeviceId: String
//    let cloudId: String
//    let applicationId: String
//    let advertisingID: String
//    
//    enum CodingKeys: String, CodingKey {
//        case iOSDeviceId = "a"
//        case cloudId = "b"
//        case applicationId = "c"
//        case advertisingID = "d"
//    }
//}

internal actor iOSDeviceIDs: Codable {
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

    init(iOSDeviceId: String, cloudId: String, applicationId: String, advertisingID: String) {
        self.iOSDeviceId = iOSDeviceId
        self.cloudId = cloudId
        self.applicationId = applicationId
        self.advertisingID = advertisingID
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(iOSDeviceId, forKey: .iOSDeviceId)
        try container.encode(cloudId, forKey: .cloudId)
        try container.encode(applicationId, forKey: .applicationId)
        try container.encode(advertisingID, forKey: .advertisingID)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            iOSDeviceId: try container.decode(String.self, forKey: .iOSDeviceId),
            cloudId: try container.decode(String.self, forKey: .cloudId),
            applicationId: try container.decode(String.self, forKey: .applicationId),
            advertisingID: try container.decode(String.self, forKey: .advertisingID)
        )
    }
}

