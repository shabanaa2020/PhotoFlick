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
    var apiResource: RecentApiResource
    var flickrPhoto: ParseFlickrPhoto?

    init() {
        apiResource = RecentApiResource(method: HTTPNetworkRoute.recentPhotos.rawValue, userId: nil)
    }
    
    func requestRecentPhotos(completion:@escaping () -> ()) {
        apiResource.getRecentPhotos{ (photos, error) in
            if let arr = photos {
                self.photos = arr
                self.flickrPhoto = ParseFlickrPhoto(photos: self.photos)
                self.flickrPhoto?.bindFlickrPhotos {
                    completion()
                }
            }
        }
    }
}
