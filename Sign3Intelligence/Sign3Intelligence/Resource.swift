//
//  Resource.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


internal enum Status {
    case success
    case error
    case loading
}

internal struct Resource<T> {
    let status: Status
    let data: T?
    let message: String?

    static func success(_ data: T?) -> Resource<T> {
        return Resource(status: .success, data: data, message: nil)
    }

    static func error(_ message: String, data: T? = nil) -> Resource<T> {
        return Resource(status: .error, data: data, message: message)
    }

    static func loading(_ data: T? = nil) -> Resource<T> {
        return Resource(status: .loading, data: data, message: nil)
    }
}
