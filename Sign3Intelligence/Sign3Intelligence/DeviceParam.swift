//
//  DeviceParam.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

//internal struct DeviceParams: Codable {
//    let iOSDataRequest: iOSDataRequest
//    let deviceIdRawData: iOSDeviceRawData
//    let networkData: iOSNetworkData
//
//    enum CodingKeys: String, CodingKey {
//        case iOSDataRequest = "a"
//        case deviceIdRawData = "b"
//        case networkData = "c"
//    }
//}

internal actor DeviceParams: Codable {
    let iOSdataRequest: iOSDataRequest
    let deviceIdRawData: iOSDeviceRawData
    let networkData: iOSNetworkData

    enum CodingKeys: String, CodingKey {
        case iOSdataRequest = "a"
        case deviceIdRawData = "b"
        case networkData = "c"
    }

    init(
        iOSdataRequest: iOSDataRequest,
        deviceIdRawData: iOSDeviceRawData,
        networkData: iOSNetworkData
    ) {
        self.iOSdataRequest = iOSdataRequest
        self.deviceIdRawData = deviceIdRawData
        self.networkData = networkData
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(iOSdataRequest, forKey: .iOSdataRequest)
        try container.encode(deviceIdRawData, forKey: .deviceIdRawData)
        try container.encode(networkData, forKey: .networkData)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            iOSdataRequest: try container.decode(iOSDataRequest.self, forKey: .iOSdataRequest),
            deviceIdRawData: try container.decode(iOSDeviceRawData.self, forKey: .deviceIdRawData),
            networkData: try container.decode(iOSNetworkData.self, forKey: .networkData)
        )
    }
}
