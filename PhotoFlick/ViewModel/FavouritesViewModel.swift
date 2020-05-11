//
//  FavouritesViewModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 22/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit

class FavouritesViewModel {
 
    var photos: [Photo] = []
    var apiResource: ApiResource
    var flickrPhoto: ParseFlickrPhoto?
    var serverImageArray = [UIImage]()
    var cdImageArray = [UIImage]()
    var coreDataObject: ImageArrayRepresentation?

    init() {
        apiResource = ApiResource(method: HTTPNetworkRoute.favouritePhotos.rawValue, userId: HTTPNetworkRoute.userId.rawValue)
    }
    
    func requestFavouritePhotos(completion:@escaping () -> ()) {
        cdImageArray = getImageArryaFromDB()
        if cdImageArray.count != 0 {
            completion()
        }else {
            apiResource.getPhotos { (photos, error)  in
                if let photoArr =  photos {
                    if photoArr.count != 0 {
                        self.photos = photoArr
                        self.flickrPhoto = ParseFlickrPhoto(photos: self.photos)
                        self.flickrPhoto?.bindFlickrPhotos {
                            for (index, _) in self.photos.enumerated() {
                                if let imageUrl = self.flickrPhoto?.photosUrl[index].flickrImageURL() {
                                    self.serverImageArray.append(LoadImages().loadImages(url: imageUrl))
                                }
                            }
                            self.saveImageArrayToDB(imageArray: self.serverImageArray)
                            self.cdImageArray = self.getImageArryaFromDB()
                            completion()
                        }
                    }else {
                        completion()
                    }
                }
            }
        }
    }
    
    func saveImageArrayToDB(imageArray: [UIImage]) {
        coreDataObject = imageArray.coreDataRepresentation()
    }
    
    func getImageArryaFromDB() -> [UIImage] {
        if let retrievedImgArray = coreDataObject?.imageArray() {
            return retrievedImgArray
        }
        return []
    }
}
