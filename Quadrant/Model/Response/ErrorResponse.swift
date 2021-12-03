//
//  ErrorResponse.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import Foundation

struct ErrorResponse: Codable, Error {
    var errorCode: Int
    var message: String
}

extension Error where Self == ErrorResponse {
    static func errorResponse(code: Int, message: String) -> ErrorResponse {
        return ErrorResponse(errorCode: code, message: message)
    }
}
