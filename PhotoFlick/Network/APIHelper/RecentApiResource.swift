//
//  RecentApiResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 09/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class RecentApiResource: ApiResource {
 
    func getRecentPhotos(_ completion: @escaping ([Photo]?, HTTPNetworkError?) -> ()) {
        do{
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: mapUrl()
            , with: [:], includes: [:], contains: nil, and: .get)
            postSession.dataTask(with: request){ (data, res, err) in
                
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(RecentPhotos.self, from: unwrappedData)
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
}
