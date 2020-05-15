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
    case publicPhotos = "flickr.photos.getContactsPhotos"
    case photoInfo = "flickr.photos.getInfo"
    case addFavourite = "flickr.favorites.add"
    case removeFavourite = "flickr.favorites.remove"
    case addComment = "flickr.photos.comments.addComment"
    case editComment = "flickr.photos.comments.editComment"
    case deleteComment = "flickr.photos.comments.deleteComment"
    case commentsList = "flickr.photos.comments.getList"
    case checkToken = "flickr.auth.oauth.checkToken"
    case favouritesForPhoto = "flickr.photos.getFavorites"
    case fotoStats = "flickr.stats.getPhotoStats"
}

public struct Endpoint {
    
    var method: String
    var userId: String?
    var params: String?
    let baseUrl   = ApiConstants.shared.baseUrl
    let apiKey = ApiConstants.shared.apiKey
    let format = ApiConstants.shared.format
    // MARK: - Lifecycle
    
    init(method: String, userId: String?, params: String?) {
        self.method = method
        self.userId = userId
        self.params = params
    }
    func mapUrl() -> String {
        let base: String
        let extras: String = "&extras=isfavorite,count_faves"
        if let userId = self.userId {
            base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)&user_id=\(userId)\(extras)&per_page=500\(params ?? "")\(format)"
        }else {
            base = baseUrl + "?method=\(self.method)&api_key=\(apiKey)\(extras)&per_page=500\(params ?? "")\(format)"
        }
        return base
    }
}
