//
//  AppSetting.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import Foundation

protocol AppSettingProtocol {
    func infoForKey(_ key: String, defaultValue: String) -> String
}

class AppSettingDelegate: AppSettingProtocol {
    func infoForKey(_ key: String, defaultValue: String) -> String {
        let dictionary = Bundle.main.infoDictionary?[AppSettingConstant.Key.config.value] as? NSDictionary
        if let value = (dictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: String.emptyString) {
            return value
        } else {
            return defaultValue
        }
    }
}

class AppSetting {
    static let shared = AppSetting()
    private var delegate: AppSettingProtocol?
    
    init(appSettingDelegate: AppSettingProtocol = AppSettingDelegate()) {
        delegate = appSettingDelegate
    }
    
    public func infoForKey(_ key: String, defaultValue: String = "") -> String {
        return delegate?.infoForKey(key, defaultValue: defaultValue) ?? ""
    }
}
