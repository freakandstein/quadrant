//
//  AppSettingConstant.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import Foundation

enum AppSettingConstant {
    enum Key: String {
        case config = "Config"
        case baseURL = "BaseURL"
        case backgroundTaskId = "BackgroundTaskId"
        
        var value: String {
            return rawValue
        }
    }
}
