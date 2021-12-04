//
//  PriceIndex.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import Foundation

struct PriceIndex: Codable {
    var dateTime: String
    var value: Double
    var longitude: String
    var latitude: String
    
    static let structName = String(describing: PriceIndex.self)
}
