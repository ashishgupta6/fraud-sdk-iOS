//
//  BaseKey.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation


internal class BaseKey {
    
    // Abstract Method
    internal var baseUrl: String{
        fatalError("Abstract class can not be instantiated!")
    }
    
}
