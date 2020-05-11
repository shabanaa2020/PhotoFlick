//
//  PostApiResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 04/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class PostApiResource: ApiResource {
    
    func postService(urlString: String, _ completion: @escaping (AddFavourite?, HTTPNetworkError?) -> ()) {
        do{
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: urlString
            , with: [:], includes: [:], contains: nil, and: .post)
            postSession.dataTask(with: request){ (data, res, err) in
                
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(AddFavourite.self, from: unwrappedData)
                        completion(result, nil)
                        
                    case .failure:
                        completion(nil, HTTPNetworkError.decodingFailed)
                    }
                }
            }.resume()
        }catch{
            completion(nil, HTTPNetworkError.badRequest)
        }

    }
    
    func mapUrl(parameters: String) -> String {
        let base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)\(parameters)\(format)"
        return base
    }
}
