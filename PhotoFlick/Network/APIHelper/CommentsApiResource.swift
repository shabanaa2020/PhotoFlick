//
//  CommentsApiResource.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 11/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class CommentsApiResource: APIClient {
    
    var session: URLSession = URLSession(configuration: .default)
    func getCommentsList(urlString: String, _ completion: @escaping (Result<CommentsList?, HTTPNetworkError>) -> ()) {
        guard let request = try? HTTPNetworkRequest.configureHTTPRequest(from: urlString
            , with: [:], includes: [:], contains: nil, and: .get) else { return }
            callAPI(with: request, decode: { json -> CommentsList? in
                guard let model = json as? CommentsList else { return nil }
                return model
            }, completion: completion)
    }
}
