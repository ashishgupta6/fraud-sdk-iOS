//
//  ProdKeyProvider.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

internal class ProdKeyProvider : BaseKey{
    
    internal override var baseUrl: String {
        return "https://intelligence.sign3.in/"
    }
}
