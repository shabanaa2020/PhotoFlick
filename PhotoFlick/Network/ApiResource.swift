//
//  ApiResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 20/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class ApiResource {

let baseURL = "https://api.flickr.com/services/rest/"
let format = "&format=json&nojsoncallback=1"

let method: String

// MARK: - Lifecycle

init(method: String) {
  self.method = method
}

//func getRequest(parameters: String, completion:@escaping (JSON) -> ()) {
//  let apiKey = ApiConstants.shared.apiKey
//  let url = baseURL + "?method=\(method)\(format)\(parameters)&api_key=\(apiKey)"
//
//  Alamofire.request(url, method: .get).validate().responseJSON { response in
//    switch response.result {
//      case .success(let value):
//        completion(JSON(value))
//      case .failure(let error):
//        print("Failed request with given url: \(url)", error)
//        completion(JSON.null)
//    }
//  }
//}

}
