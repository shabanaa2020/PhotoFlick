//
//  FlickrPhotoResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 04/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class FlickrPhotoResource : ApiResource {
        
    func getPhotoInfo(photoId: String, _ completion: @escaping (PhotoInfoModel?, HTTPNetworkError?) -> ()) {
        do{
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: mapUrl(photoId: photoId)
            , with: [:], includes: [:], contains: nil, and: .get)
            postSession.dataTask(with: request){ (data, res, err) in
                
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(PhotoInfoModel.self, from: unwrappedData)
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
    
    fileprivate func mapUrl(photoId: String) -> String {
        let base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)&photo_id=\(photoId)\(format)"
        return base
    }
}
