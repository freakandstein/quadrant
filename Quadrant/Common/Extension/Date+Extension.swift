//
//  Date+Extension.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 05/12/21.
//

import Foundation

extension Date {
    
    func toString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
