//
//  PhotoModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 23/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit

struct FlickrPhoto : Equatable {
  let photoID : String
  let farm : Int
  let server : String
  let secret : String
  
  init (photoID:String,farm:Int, server:String, secret:String) {
    self.photoID = photoID
    self.farm = farm
    self.server = server
    self.secret = secret
  }
  
  func flickrImageURL(_ size:String = "m") -> URL? {
    if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
      return url
    }
    return nil
  }
  
}

func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
  return lhs.photoID == rhs.photoID
}
