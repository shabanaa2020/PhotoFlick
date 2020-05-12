//
//  DetailViewModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 24/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

class DetailViewModel {
    
    var navigationTitle: String = ""
    var photoObject: Photo?
    var photoUrl: FlickrPhoto?
    var photoId: String?
    var commentsList: [Comment]?
    
    
    func getCommentsList(completion:@escaping () -> ()) {
        let getCommentsApiResource = CommentsApiResource(method: HTTPNetworkRoute.commentsList.rawValue, userId: nil)
        getCommentsApiResource.getCommentsList(urlString: getCommentsApiResource.mapUrl(parameters: mapFavParams(with: photoId ?? ""))) { (response, error) in
            self.commentsList = response?.comments?.comment
            completion()
        }
    }

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
        let favsPostApiResource = PostApiResource(method: HTTPNetworkRoute.addFavourite.rawValue, userId: nil)
        favsPostApiResource.postService(urlString: favsPostApiResource.mapUrl(parameters: mapFavParams(with: photoId))) { (response, error) in
            completion(response)
        }
    }
    
    func removeFavourite(photoId: String, completion:@escaping (AddFavourite?) -> ()) {
        let favsPostApiResource = PostApiResource(method: HTTPNetworkRoute.removeFavourite.rawValue, userId: nil)
        favsPostApiResource.postService(urlString: favsPostApiResource.mapUrl(parameters: mapFavParams(with: photoId))) { (response, error) in
            completion(response)
        }
    }
    
    func addComments(photoId: String, commentTxt: String, completion:@escaping (AddFavourite?) -> ()) {
        let commentsPostApiResource = PostApiResource(method: HTTPNetworkRoute.addComment.rawValue, userId: nil)
        commentsPostApiResource.postService(urlString: commentsPostApiResource.mapUrl(parameters: mapCommentsParams(with: photoId, comments: commentTxt))) { (response, error) in
            completion(response)
        }
    }
    
    func deleteComments(photoId: String, commentId: String, completion:@escaping (AddFavourite?) -> ()) {
        let commentsPostApiResource = PostApiResource(method: HTTPNetworkRoute.deleteComment.rawValue, userId: nil)
        commentsPostApiResource.postService(urlString: commentsPostApiResource.mapUrl(parameters: mapDeleteCommentParams(with: photoId, commentId: commentId))) { (response, error) in
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
    
    private func mapDeleteCommentParams(with photoId: String, commentId: String) -> String {
        let url = "&photo_id=\(photoId)&comment_id=\(commentId)"
        return url
    }
}
