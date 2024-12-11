//
//  EventMetric.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


internal struct EventMetric: Codable {
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
}
