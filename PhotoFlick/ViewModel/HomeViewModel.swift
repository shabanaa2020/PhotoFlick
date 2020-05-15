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
    var navigationTitle: String
    var flickrPhoto: ParseFlickrPhoto?
    
    init() {
        navigationTitle = AppConstants.GeneralConstants.home_navigation_title
    }
    
    func requestAllPublicPhotos(completion:@escaping (Error?) -> ()) {
        let apiResource = ApiResource()
        apiResource.getPublicPhotos{ (photos, error) in
            if let arr = photos {
                self.photos = arr
                self.flickrPhoto = ParseFlickrPhoto(photos: self.photos)
                self.flickrPhoto?.bindFlickrPhotos {
                    completion(error)
                }
            }
        }
    }
}
