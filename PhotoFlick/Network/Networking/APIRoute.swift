//
//  APIRoute.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 04/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

public enum HTTPNetworkRoute: String{
    
    case testLogin = "flickr.test.login"
    case recentPhotos = "flickr.photos.getRecent"
    case favouritePhotos = "flickr.favorites.getList"
    case publicPhotos = "flickr.people.getPublicPhotos"
    case photoInfo = "flickr.photos.getInfo"
    case addFavourite = "flickr.favorites.add"
    case removeFavourite = "flickr.favorites.remove"
    case addComment = "flickr.photos.comments.addComment"
    case deleteComment = "flickr.photos.comments.deleteComment"
    case userId = "187826686@N03"
    
}
