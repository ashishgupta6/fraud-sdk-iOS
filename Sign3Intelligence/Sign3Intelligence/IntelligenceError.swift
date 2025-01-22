//
//  IntelligenceError.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

public struct IntelligenceError: Codable {
    public let requestId: String
    public let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case requestId = "requestId"
        case errorMessage = "errorMessage"
    }
    
}


