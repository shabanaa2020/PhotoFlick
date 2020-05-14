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
    
    func getFavPhotos(_ completion: @escaping ([Photo]?, HTTPNetworkError?) -> ()) {
        
        OauthService.shared.oauthswift?.client.get(mapUrl(), completionHandler: { (result) in
            switch(result) {
            case .success(let response):
                let jsonDict = try? response.jsonObject()
                print(jsonDict as Any)
                let result = try? JSONDecoder().decode(AllPhotos.self, from: response.data)
                completion(result?.photos?.photo, nil)
                break;
            case .failure(let error):
                print(error)
                break;
            }
        })
    }
    
    func getPublicPhotos(_ completion: @escaping ([Photo]?, HTTPNetworkError?) -> ()) {
        
        OauthService.shared.oauthswift?.client.get(mapUrl(), completionHandler: { (result) in
            switch(result) {
            case .success(let response):
                let jsonDict = try? response.jsonObject()
                print(jsonDict as Any)
                let result = try? JSONDecoder().decode(AllPublicPhotos.self, from: response.data)
                completion(result?.photos?.photo, nil)
                break;
            case .failure(let error):
                print(error)
                break;
            }
        })
    }
    
    func getPhotoFavourites(urlString: String, _ completion: @escaping (PhotoFavourites?, HTTPNetworkError?) -> ()) {
        do{
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: urlString
            , with: [:], includes: [:], contains: nil, and: .get)
            postSession.dataTask(with: request){ (data, res, err) in
                
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(PhotoFavourites.self, from: unwrappedData)
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
    
    func getUserId(_ completion: @escaping (UserInfo?, HTTPNetworkError?) -> ()) {
        
        OauthService.shared.oauthswift?.client.get(mapUrl(), completionHandler: { (result) in
            switch(result) {
            case .success(let response):
                let jsonDict = try? response.jsonObject()
                print(jsonDict as Any)
                let result = try? JSONDecoder().decode(UserInfo.self, from: response.data)
                completion(result, nil)
                break;
            case .failure(let error):
                print(error)
                break;
            }
        })
    }
    
    func mapUrl() -> String {
        let base: String
        let extras: String = "&extras=isfavorite,count_faves"
        if let userId = self.userId {
            base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)&user_id=\(userId)\(extras)&per_page=500\(format)"
        }else {
            base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)\(extras)&per_page=500\(format)"
        }
        return base
    }
    
    func mapPhotoFavUrl(parameters: String) -> String {
        let base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)&extras=count_faves\(parameters)\(format)"
        return base
    }
}
