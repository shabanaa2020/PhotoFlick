//
//  Encoder.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 04/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

public struct URLEncoder {
    
    /// Encode and set the parameters of a url request
    static func encodeParameters(for urlRequest: inout URLRequest, with parameters: HTTPParameters) throws {
        guard let url = urlRequest.url else { throw HTTPNetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !(parameters?.isEmpty ?? false) {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters ?? [:] {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                
                urlComponents.queryItems?.append(queryItem)
            }
            
            urlRequest.url = urlComponents.url
        }
        
    }
    
    /// Set the addition http headers of the request
    static func setHeaders(for urlRequest: inout URLRequest, with headers: HTTPHeaders) throws {
        
        for (key, value) in headers ?? [:]{
            urlRequest.setValue(value as? String, forHTTPHeaderField: key)
        }
    }
}
