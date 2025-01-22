//
//  DataRequest.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct DataRequestData: Codable {
    let requestId: String
    let sessionId: String
    let deviceParams: DeviceParams
    var clientParams: ClientParams
    
    enum CodingKeys: String, CodingKey {
        case requestId = "a"
        case sessionId = "b"
        case deviceParams = "c"
        case clientParams = "d"
    }
}

internal actor DataRequest: Codable {
    let requestId: String
    let sessionId: String
    let deviceParams: DeviceParams
    var clientParams: ClientParams
    
    enum CodingKeys: String, CodingKey {
        case requestId = "a"
        case sessionId = "b"
        case deviceParams = "c"
        case clientParams = "d"
    }
    
    func setClientParams(_ clientParams: ClientParams) {
        self.clientParams = clientParams
    }
    
    func getData() -> DataRequestData {
        return DataRequestData(requestId: self.requestId, sessionId: self.sessionId, deviceParams: self.deviceParams, clientParams: self.clientParams)
    }
    
    init(requestId: String, sessionId: String, deviceParams: DeviceParams, clientParams: ClientParams) {
        self.requestId = requestId
        self.sessionId = sessionId
        self.deviceParams = deviceParams
        self.clientParams = clientParams
    }
    
    nonisolated func encode(to encoder: Encoder) throws {
        Task {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(requestId, forKey: .requestId)
            try container.encode(sessionId, forKey: .sessionId)
            try container.encode(deviceParams, forKey: .deviceParams)
            try await container.encode(clientParams, forKey: .clientParams)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let requestId = try container.decode(String.self, forKey: .requestId)
        let sessionId = try container.decode(String.self, forKey: .sessionId)
        let deviceParams = try container.decode(DeviceParams.self, forKey: .deviceParams)
        let clientParams = try container.decode(ClientParams.self, forKey: .clientParams)
        self.init(requestId: requestId, sessionId: sessionId, deviceParams: deviceParams, clientParams: clientParams)
    }
}

