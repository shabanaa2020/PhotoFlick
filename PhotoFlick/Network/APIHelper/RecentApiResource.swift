//
//  RecentApiResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 09/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class RecentApiResource: APIClient {
    
    var session: URLSession = URLSession(configuration: .default)
    
    func getRecentPhotos(urlString: String, _ completion: @escaping (Result<RecentPhotos?, HTTPNetworkError>) -> ()) {
        guard let request = try? HTTPNetworkRequest.configureHTTPRequest(from: urlString
            , with: [:], includes: [:], contains: nil, and: .get) else { return }
        callAPI(with: request, decode: { json -> RecentPhotos? in
            guard let model = json as? RecentPhotos else { return nil }
            return model
        }, completion: completion)
    }
}
