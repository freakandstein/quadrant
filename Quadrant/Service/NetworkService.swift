//
//  NetworkService.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 03/12/21.
//

import Foundation
import Moya

protocol NetworkServiceProtocol: AnyObject {
    func request<T: TargetType, M: Decodable>(target: T, model: M.Type, completion: @escaping (Result<M, Error>) -> Void)
}

class Provider: NetworkServiceProtocol {
    
    private var provider: MoyaProvider<MultiTarget>?
    private var isDebug: Bool
    
    init(isDebugMode: Bool = false) {
        isDebug = isDebugMode
        if isDebug {
            provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin()])
        } else {
            provider = MoyaProvider<MultiTarget>()
        }
    }
    
    public func request<T, M>(target: T, model: M.Type, completion: @escaping (Result<M, Error>) -> Void) where T : TargetType, M : Decodable {
        self.provider?.request(MultiTarget(target)) { (result) in
            switch result {
            case .success(let response):
                do {
                    if response.statusCode != 200 {
                        let statusCode = response.statusCode
                        let errorMessage: String
                        // Implement only some common statusCodes
                        switch statusCode {
                        case 404:
                            errorMessage = "HTTP Not Found"
                        case 409:
                            errorMessage = "HTTP Conflict"
                        case 500:
                            errorMessage = "Internal Server Error"
                        case 502:
                            errorMessage = "Bad Gateway"
                        default:
                            errorMessage = "General Error"
                        }
                        completion(.failure(.errorResponse(code: statusCode, message: errorMessage)))
                    } else {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let result = try filteredResponse.map(model)
                        completion(.success(result))
                    }
                } catch(let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class NetworkService {
    static var instance = NetworkService()
    private var delegate: NetworkServiceProtocol?
    
    init(networkServiceProtocol: NetworkServiceProtocol = Provider()) {
        self.delegate = networkServiceProtocol
    }
    
    public func request<T: TargetType, M: Decodable>(target: T, model modelType: M.Type, completion: @escaping (Result<M, Error>) -> Void ){
        self.delegate?.request(target: target, model: modelType, completion: completion)
    }
}
