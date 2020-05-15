//
//  NetworkManager.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 15/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

protocol APIClient {
    var session: URLSession { get }
    func callAPI<T: Decodable> (with request: URLRequest, decode: @escaping (Decodable) -> T?,
                              completion: @escaping (Result<T, HTTPNetworkError>) -> Void)
}

extension APIClient {
    typealias jsonTaskCompletionHandler = (Decodable?, HTTPNetworkError?) -> Void
    
    private func decodingTask<T: Decodable> (with request: URLRequest, decodingType: T.Type, completion: @escaping jsonTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    func callAPI<T: Decodable> (with request: URLRequest, decode: @escaping (Decodable) -> T?,
                              completion: @escaping (Result<T, HTTPNetworkError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { (json, error) in
            
            // Switch to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
                if let value = decode(json) {
                    completion(Result.success(value))
                } else {
                    completion(Result.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
}
