//
//  ProdKeyProvider.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

class ProdKeyProvider : BaseKey{
    
    override var baseUrl: String {
        return "https://intelligence.sign3.in/"
    }
}
