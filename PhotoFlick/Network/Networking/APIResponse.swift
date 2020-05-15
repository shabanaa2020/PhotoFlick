//
//  APIResponse.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 04/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct HTTPNetworkResponse {
    
    static func handleNetworkResponse(for response: HTTPURLResponse?) -> Result<String, HTTPNetworkError>{
        
        guard let res = response else { return Result.failure(HTTPNetworkError.UnwrappingError)}
        
        switch res.statusCode {
        case 200...299: return .success(HTTPNetworkError.success.rawValue)
        case 401: return .failure(HTTPNetworkError.authenticationError)
        case 400...499: return .failure(HTTPNetworkError.badRequest)
        case 500...599: return .failure(HTTPNetworkError.serverSideError)
        default: return .failure(HTTPNetworkError.failed)
        }
    }
    
}
