//
//  DevKeyProvider.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation


class DevKeyProvider: BaseKey{
    
    internal override var baseUrl: String {
        return "https://intelligence-dev.sign3.in/"
    }
}
