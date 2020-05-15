//
//  ApiResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 22/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class ApiResource: APIClient {
    
    var session: URLSession = URLSession(configuration: .default)
    
    let postSession = URLSession(configuration: .default)
    
    func getFavPhotos(_ completion: @escaping ([Photo]?, HTTPNetworkError?) -> ()) {
        
        OauthService.shared.oauthswift?.client.get(Endpoint(method: HTTPNetworkRoute.favouritePhotos.rawValue, userId: DataManager.user_id, params: nil).mapUrl(), completionHandler: { (result) in
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
        
        OauthService.shared.oauthswift?.client.get(Endpoint(method: HTTPNetworkRoute.publicPhotos.rawValue, userId: DataManager.user_id, params: nil).mapUrl(), completionHandler: { (result) in
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
    
    func getPhotoFavourites(urlString: String, _ completion: @escaping (Result<PhotoFavourites?, HTTPNetworkError>) -> ()) {
        guard let request = try? HTTPNetworkRequest.configureHTTPRequest(from: urlString
            , with: [:], includes: [:], contains: nil, and: .get) else { return }
        
        callAPI(with: request, decode: { json -> PhotoFavourites? in
            guard let model = json as? PhotoFavourites else { return nil }
            return model
        }, completion: completion)
    }
    
    func getUserId(_ completion: @escaping (UserInfo?, HTTPNetworkError?) -> ()) {
        
        OauthService.shared.oauthswift?.client.get(Endpoint(method: HTTPNetworkRoute.testLogin.rawValue, userId: nil, params: nil).mapUrl(), completionHandler: { (result) in
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
//
//    func mapPhotoFavUrl(parameters: String) -> String {
//        let base =  baseUrl + "?method=\(self.method)&api_key=\(apiKey)&extras=count_faves\(parameters)\(format)"
//        return base
//    }
}
