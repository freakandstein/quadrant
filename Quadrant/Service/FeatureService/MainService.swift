//
//  MainService.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import Foundation
import Moya

enum MainService {
    case getCurrentPrice
}

extension MainService: TargetType {
    
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL {
        let _baseURL = AppSetting.shared.infoForKey(AppSettingConstant.Key.baseURL.value)
        let version = "v1"
        let baseURLWithVersion = _baseURL + version
        return URL(string: baseURLWithVersion)!
    }
    
    var path: String {
        switch self {
        case .getCurrentPrice:
            return "/bpi/currentprice.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var parameter: [String: Any] {
        return [:]
    }
}
