//
//  HomeViewModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 22/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    var photos: [Photo] = []
    var apiResource: ApiResource
    var navigationTitle: String
    var flickrPhoto: ParseFlickrPhoto?
    
    init() {
        navigationTitle = AppConstants.GeneralConstants.home_navigation_title
        apiResource = ApiResource(method: HTTPNetworkRoute.publicPhotos.rawValue, userId: HTTPNetworkRoute.userId.rawValue)
    }
    
    func requestAllPublicPhotos(completion:@escaping () -> ()) {
        apiResource.getPhotos { (photos, error) in
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
