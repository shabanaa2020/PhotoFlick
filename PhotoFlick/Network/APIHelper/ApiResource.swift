//
//  ApiResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 22/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class ApiResource {
    
    var method: String
    var userId: String?
    let baseUrl   = ApiConstants.shared.baseUrl
    let apiKey = ApiConstants.shared.apiKey
    let format = ApiConstants.shared.format
    // MARK: - Lifecycle
    
    init(method: String, userId: String?) {
        self.method = method
        self.userId = userId
    }
    
    let postSession = URLSession(configuration: .default)
    
    func getPhotos(_ completion: @escaping ([Photo]?, HTTPNetworkError?) -> ()) {
        do{
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: mapUrl()
            , with: [:], includes: [:], contains: nil, and: .get)
            postSession.dataTask(with: request){ (data, res, err) in
                
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(AllPhotos.self, from: unwrappedData)
                        if let res = result {
                            completion(res.photos?.photo, nil)
                        }
                        
                    case .failure:
                        completion(nil, HTTPNetworkError.decodingFailed)
                    }
                }
            }.resume()
        }catch{
            completion(nil, HTTPNetworkError.badRequest)
        }

    }
    
    func mapUrl() -> String {
        let base: String
        if let userId = self.userId {
            base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)&user_id=\(userId)\(format)"
        }else {
            base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)\(format)"
        }
        return base
    }
}
