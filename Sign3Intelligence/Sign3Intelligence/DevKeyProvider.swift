//
//  DevKeyProvider.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation


class DevKeyProvider: BaseKey{
    
    internal override var baseUrl: String {
        return "http://172.16.48.219:25000/"
        //return "https://intelligence-dev.sign3.in/"
    }
}
