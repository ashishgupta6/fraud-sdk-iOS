//
//  EventMetric.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

//
//internal struct EventMetric: Codable {
//    let timeRequiredInMs: Int64
//    let status: Bool
//    let source: String?
//    let errorMessage: String?
//    let requestId: String?
//    let eventName: String
//    
//    enum CodingKeys: String, CodingKey {
//        case timeRequiredInMs = "timeRequiredInMs"
//        case status = "status"
//        case source = "source"
//        case errorMessage = "errorMessage"
//        case requestId = "requestId"
//        case eventName = "eventName"
//    }
//}

internal actor EventMetric: Codable {
    let timeRequiredInMs: Int64
    let status: Bool
    let source: String?
    let errorMessage: String?
    let requestId: String?
    let eventName: String
    
    enum CodingKeys: String, CodingKey {
        case timeRequiredInMs = "timeRequiredInMs"
        case status = "status"
        case source = "source"
        case errorMessage = "errorMessage"
        case requestId = "requestId"
        case eventName = "eventName"
    }
    
    init(timeRequiredInMs: Int64, status: Bool, source: String? = nil, errorMessage: String? = nil, requestId: String? = nil, eventName: String) {
        self.timeRequiredInMs = timeRequiredInMs
        self.status = status
        self.source = source
        self.errorMessage = errorMessage
        self.requestId = requestId
        self.eventName = eventName
    }
    
    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timeRequiredInMs, forKey: .timeRequiredInMs)
        try container.encode(status, forKey: .status)
        try container.encode(source, forKey: .source)
        try container.encode(errorMessage, forKey: .errorMessage)
        try container.encode(requestId, forKey: .requestId)
        try container.encode(eventName, forKey: .eventName)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeRequiredInMs = try container.decode(Int64.self, forKey: .timeRequiredInMs)
        let status = try container.decode(Bool.self, forKey: .status)
        let source = try container.decode(String?.self, forKey: .source)
        let errorMessage = try container.decode(String?.self, forKey: .errorMessage)
        let requestId = try container.decode(String?.self, forKey: .requestId)
        let eventName = try container.decode(String.self, forKey: .eventName)
        self.init(timeRequiredInMs: timeRequiredInMs, status: status, source: source, errorMessage: errorMessage, requestId: requestId, eventName: eventName)
    }
}

