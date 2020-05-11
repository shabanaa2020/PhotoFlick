//
//  FlickrPhoto.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 04/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class ParseFlickrPhoto {
    
    var photos: [Photo]
    var photosUrl: [FlickrPhoto] = []
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func bindFlickrPhotos(completion:@escaping () -> ()) {
        var flickrPhotos = [FlickrPhoto]()
        
        for photoObject in photos {
            guard let photoID = photoObject.id,
                let farm = photoObject.farm ,
                let server = photoObject.server ,
                let secret = photoObject.secret else {
                    break
            }
            let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
            flickrPhotos.append(flickrPhoto)
            photosUrl.append(flickrPhoto)
        }
        completion()
    }
    
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto? {
        return photosUrl[(indexPath as NSIndexPath).row]
    }
    
}
