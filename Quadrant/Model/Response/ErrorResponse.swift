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
    
    static func generalError() -> ErrorResponse {
        return ErrorResponse(errorCode: 000, message: "General Error")
    }
    
    static func saveError() -> ErrorResponse {
        return ErrorResponse(errorCode: 001, message: "Save Data Error")
    }
    
    static func loadError() -> ErrorResponse {
        return ErrorResponse(errorCode: 002, message: "Load Data Error")
    }
}
