//
//  ActionContextSource.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/12/24.
//

import Foundation

internal enum ActionContextSource {
    case INIT
    case BACKGROUND
    case CRON
    case APP_RESUME
    case GET
    case ERROR
}
