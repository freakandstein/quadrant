//
//  DateFormatConstant.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 04/12/21.
//

import Foundation

enum DateFormatConstant: String {
    case formatISO = "yyyy-MM-dd'T'HH:mm:ssZ"
    case days = "dd"
    case time = "HH:mm"
    case hours = "HH"
    case daily = "EEE, d MMM yyyy"
    
    var value: String {
        return rawValue
    }
}
