//
//  String+Extension.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import Foundation

extension String {
    static let emptyString = ""
    
    func formatDateInString(convertDateTo format: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = DateFormatConstant.formatISO.value
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        
        let date = dateFormatterGet.date(from: self) ?? Date()
        return dateFormatterPrint.string(from: date)
    }
    
    func toDate() -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = DateFormatConstant.formatISO.value
        return dateFormatterGet.date(from: self) ?? Date()
    }
}
