//
//  StagingKeyProvider.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

class StagingKeyProvider: BaseKey{
    
    internal override var baseUrl: String {
        return "https://intelligence-staging.sign3.in/"
//        return "https://2afb-14-140-38-186.ngrok-free.app/"
    }
}
