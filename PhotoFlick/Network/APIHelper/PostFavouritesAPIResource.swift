//
//  PostFavouritesAPIResource.swift
//  PhotoFlick
//
//  Created by Prakashini Pattabiraman on 12/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class PostFavouritesAPIResource: ApiResource {
    
    func postService(urlString: String, _ completion: @escaping (AddFavourite?, HTTPNetworkError?) -> ()) {
        
        OauthService.shared.oauthswift?.client.post(urlString, completionHandler: { (result) in
            switch(result) {
            case .success(let response):
                let jsonDict = try? response.jsonObject()
                print(jsonDict as Any)
                let result = try? JSONDecoder().decode(AddFavourite.self, from: response.data)
                completion(result, nil)
                break;
            case .failure(let error):
                print(error)
                break;
            }
        })
    }
    
    func checkAccessToken(urlString: String, _ completion: @escaping (CheckAccessTokenModel?, HTTPNetworkError?) -> ()) {
        
        OauthService.shared.oauthswift?.client.get(urlString, completionHandler: { (result) in
            switch(result) {
            case .success(let response):
                let result = try? JSONDecoder().decode(CheckAccessTokenModel.self, from: response.data)
                completion(result, nil)
                break;
            case .failure(let error):
                print(error)
                break;
            }
        })
        
    }
    
    func mapUrl(parameters: String) -> String {
        let base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)\(parameters)\(format)"
        return base
    }
}
