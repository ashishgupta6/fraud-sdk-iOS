//
//  StagingKeyProvider.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

class StagingKeyProvider: BaseKey{
    
    override var baseUrl: String {
        return "https://intelligence-staging.sign3.in/"
    }
}
