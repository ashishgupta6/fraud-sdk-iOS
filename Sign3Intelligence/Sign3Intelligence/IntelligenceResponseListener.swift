//
//  IntelligenceResponseListener.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


public protocol IntelligenceResponseListener {
    func onSuccess(response: IntelligenceResponse)
    func onError(error: IntelligenceError)
}
