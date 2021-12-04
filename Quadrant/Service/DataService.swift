//
//  DataService.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 04/12/21.
//

import Foundation

protocol DataServiceProtocol: AnyObject {
    func save<T: Codable>(data: [T], key: String) throws
    func load(key: String) throws -> Data
    func remove(key: String) throws
}

class DataServiceProvider: DataServiceProtocol {
    
    let userDefault = UserDefaults.standard
    
    func save<T: Codable>(data: [T], key: String) throws {
        if let encoded = try? JSONEncoder().encode(data) {
            userDefault.set(encoded, forKey: key)
        } else {
            throw .saveError()
        }
    }
    
    func load(key: String) throws -> Data {
        if let data = userDefault.object(forKey: key) as? Data {
            return data
        }
        throw .loadError()
    }
    
    func remove(key: String) throws {
        userDefault.removeObject(forKey: key)
    }
}

class DataService {
    static let shared: DataServiceProtocol = DataServiceProvider()
}
