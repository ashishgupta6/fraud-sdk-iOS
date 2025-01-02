//
//  StagingKeyProvider.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

class StagingKeyProvider: BaseKey{
    
    internal override var baseUrl: String {
        //return "http://14.140.38.186:25000/"
        return "https://intelligence-staging.sign3.in/"
    }
}
