//
//  RecentViewModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 24/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class RecentViewModel {

    var photos: [Photo] = []
    var flickrPhoto: ParseFlickrPhoto?
    var navigationTitle: String
    
    init() {
        navigationTitle = AppConstants.GeneralConstants.recent_navigation_title
    }
    
    func requestRecentPhotos(completion:@escaping (HTTPNetworkError?) -> ()) {
        let apiResource = RecentApiResource()
        let endpoint = Endpoint(method: HTTPNetworkRoute.recentPhotos.rawValue, userId: nil, params: nil)
        apiResource.getRecentPhotos(urlString: endpoint.mapUrl()) { (response) in
            switch response {
            case .success(let result):
                if let arr = result?.photos?.photo {
                    self.photos = arr
                    self.flickrPhoto = ParseFlickrPhoto(photos: self.photos)
                    self.flickrPhoto?.bindFlickrPhotos {
                        completion(nil)
                    }
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
}
