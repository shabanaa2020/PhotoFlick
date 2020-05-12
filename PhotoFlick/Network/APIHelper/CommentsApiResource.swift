//
//  CommentsApiResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 11/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class CommentsApiResource: ApiResource {
    
    func getCommentsList(urlString: String, _ completion: @escaping (CommentsList?, HTTPNetworkError?) -> ()) {
        do{
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: urlString
                , with: [:], includes: [:], contains: nil, and: .get)
            postSession.dataTask(with: request){ (data, res, err) in
                
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(CommentsList.self, from: unwrappedData)
                        if let res = result {
                            completion(res, nil)
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
    
    func mapUrl(parameters: String) -> String {
        let base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)\(parameters)\(format)"
        return base
    }
}
