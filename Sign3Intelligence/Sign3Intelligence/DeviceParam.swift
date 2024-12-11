//
//  DeviceParam.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct DeviceParams: Codable {
    let iOSDataRequest: iOSDataRequest
    let deviceIdRawData: iOSDeviceRawData
    let networkData: iOSNetworkData

    enum CodingKeys: String, CodingKey {
        case iOSDataRequest = "a"
        case deviceIdRawData = "b"
        case networkData = "c"
    }
}
