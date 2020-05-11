//
//  DetailViewModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 24/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class DetailViewModel {
    
    var navigationTitle: String
    var photoObject: Photo?
    var photoUrl: FlickrPhoto?
    var photoId: String?
    var apiResource: FlickrPhotoResource
    var favsPostApiResource: PostApiResource
    var commentsPostApiResource: PostApiResource
    
    init() {
        self.navigationTitle = ""
        apiResource = FlickrPhotoResource(method: HTTPNetworkRoute.photoInfo.rawValue, userId: nil)
        favsPostApiResource = PostApiResource(method: HTTPNetworkRoute.addFavourite.rawValue, userId: nil)
        commentsPostApiResource = PostApiResource(method: HTTPNetworkRoute.addComment.rawValue, userId: nil)
    }
    
//    func requestPhotoInfo(completion:@escaping () -> ()) {
//        apiResource.getPhotoInfo(photoId: photoId ?? "") { (json, error) in
//            self.photoObject = json?.photo
//            self.bindFlickrPhoto {
//                completion()
//            }
//        }
//    }
    
    func bindFlickrPhoto(completion:@escaping () -> ()) {
        guard let photoID = photoObject?.id,
            let farm = photoObject?.farm ,
            let server = photoObject?.server ,
            let secret = photoObject?.secret else {
                return
        }
        let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
        self.photoUrl = flickrPhoto
        completion()
    }
    
    func addFavourite(photoId: String, completion:@escaping (AddFavourite?) -> ()) {
        favsPostApiResource.postService(urlString: favsPostApiResource.mapUrl(parameters: mapFavParams(with: photoId))) { (response, error) in
            completion(response)
        }
    }
    
    func removeFavourite(photoId: String, completion:@escaping (AddFavourite?) -> ()) {
        favsPostApiResource.postService(urlString: favsPostApiResource.mapUrl(parameters: mapFavParams(with: photoId))) { (response, error) in
            completion(response)
        }
    }
    
    func addComments(photoId: String, commentTxt: String, completion:@escaping (AddFavourite?) -> ()) {
        commentsPostApiResource.postService(urlString: commentsPostApiResource.mapUrl(parameters: mapCommentsParams(with: photoId, comments: commentTxt))) { (response, error) in
                completion(response)
        }
    }
    
    private func mapFavParams(with photoId: String) -> String {
        let url = "&photo_id=\(photoId)"
        return url
    }
    
    private func mapCommentsParams(with photoId: String, comments: String) -> String {
        let url = "&photo_id=\(photoId)&comment_text=\(comments)"
        return url
    }
}
