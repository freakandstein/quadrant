//
//  UIConstant.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 04/12/21.
//

import Foundation

enum UIConstant {
    enum LineWidth: Int {
        case thin = 1
        case medium = 3
        case bold = 5
        
        var value: Int {
            return rawValue
        }
    }
    
    enum FormSize: Int {
        case small = 1
        case medium = 3
        case big = 5
        
        var value: Int {
            return rawValue
        }
    }
    
    enum Duration: Double {
        case glance = 0.25
        case veryShort = 0.5
        case short = 1.0
        case long = 2.0
        
        var value: Double {
            return rawValue
        }
    }
}
