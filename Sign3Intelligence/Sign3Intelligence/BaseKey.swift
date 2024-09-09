//
//  BaseKey.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation


class BaseKey {
    
    // Abstract Method
    var baseUrl: String{
        fatalError("Abstract class can not be instantiated!")
    }
    
}
