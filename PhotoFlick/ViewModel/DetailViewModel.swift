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
    var photoFavs: PhotoFavourites?
    var datesArr: [String?] = []
    var favesCountArray: [String?] = []
    var apiResource = ApiResource()

    func getCommentsList(completion:@escaping (HTTPNetworkError?) -> ()) {
        let endpoint = Endpoint(method: HTTPNetworkRoute.commentsList.rawValue, userId: nil, params: mapFavParams(with: photoId ?? ""))
        let getCommentsApiResource = CommentsApiResource()
        getCommentsApiResource.getCommentsList(urlString: endpoint.mapUrl()) { (response) in
            switch response {
            case .success(let commentsModel):
                self.commentsList = commentsModel?.comments?.comment
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func getPhotoFavourites(completion:@escaping (HTTPNetworkError?) -> ()) {
        let endpoint = Endpoint(method: HTTPNetworkRoute.favouritesForPhoto.rawValue, userId: nil, params: mapFavParams(with: photoId ?? ""))
        apiResource.getPhotoFavourites(urlString: endpoint.mapUrl()) { (response) in
            switch response {
            case .success(let photoFavModel):
                self.photoFavs = photoFavModel.self
                completion(nil)
            case .failure(let error):
                completion(error)
            }
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
    
    func checkToken(completion:@escaping (CheckAccessTokenModel?) -> ()) {
        let endpoint = Endpoint(method: HTTPNetworkRoute.checkToken.rawValue, userId: nil, params: mapCheckToken())
        let checkTokenApiResource = PostFavouritesAPIResource()
        checkTokenApiResource.checkAccessToken(urlString: endpoint.mapUrl()) { (response, error) in
            completion(response)
        }
    }
    
    func addFavourite(photoId: String, completion:@escaping (AddFavourite?) -> ()) {
        let endpoint = Endpoint(method: HTTPNetworkRoute.addFavourite.rawValue, userId: nil, params: mapFavParams(with: photoId))
        let favsPostAPI = PostFavouritesAPIResource()
        favsPostAPI.postService(urlString: endpoint.mapUrl()) { (response, error) in
            completion(response)
        }
    }
    
    func removeFavourite(photoId: String, completion:@escaping (AddFavourite?) -> ()) {
        let endpoint = Endpoint(method: HTTPNetworkRoute.removeFavourite.rawValue, userId: nil, params: mapFavParams(with: photoId))
        let favsPostAPI = PostFavouritesAPIResource()
        favsPostAPI.postService(urlString: endpoint.mapUrl()) { (response, error) in
            completion(response)
        }
    }
    
    func addComments(photoId: String, commentTxt: String, completion:@escaping (AddCommentResponse?) -> ()) {
        let endpoint = Endpoint(method: HTTPNetworkRoute.addComment.rawValue, userId: nil, params: mapCommentsParams(with: photoId, comments: commentTxt))
        let commentsPostAPI = PostFavouritesAPIResource()
        commentsPostAPI.postCommentsService(urlString: endpoint.mapUrl()) { (response, error) in
            completion(response)
        }
    }
    
    func editComments(commentId: String, commentTxt: String, completion:@escaping (AddCommentResponse?) -> ()) {
        let endpoint = Endpoint(method: HTTPNetworkRoute.editComment.rawValue, userId: nil, params: mapEditCommentsParams(with: commentId, comments: commentTxt))
        let commentsPostAPI = PostFavouritesAPIResource()
        commentsPostAPI.postCommentsService(urlString: endpoint.mapUrl()) { (response, error) in
            completion(response)
        }
    }
    
    func deleteComments(photoId: String, commentId: String, completion:@escaping (AddFavourite?) -> ()) {
        let endpoint = Endpoint(method: HTTPNetworkRoute.deleteComment.rawValue, userId: nil, params: mapDeleteCommentParams(with: photoId, commentId: commentId))
        let commentsPostAPI = PostFavouritesAPIResource()
        commentsPostAPI.postService(urlString: endpoint.mapUrl()) { (response, error) in
            completion(response)
        }
    }

    private func mapFavParams(with photoId: String) -> String {
        let url = "&photo_id=\(photoId)&per_page=\(AppConstants.NumericConstants.maxFavsToFetch)"
        return url
    }
    
    private func mapCheckToken() -> String {
        let url = "&oauth_token=\(DataManager.access_token)"
        return url
    }
    
    private func mapCommentsParams(with photoId: String, comments: String) -> String {
        let url = "&photo_id=\(photoId)&comment_text=\(comments)"
        return url
    }
    
    private func mapEditCommentsParams(with commentId: String, comments: String) -> String {
        let url = "&comment_id=\(commentId)&comment_text=\(comments)"
        return url
    }
    
    private func mapDeleteCommentParams(with photoId: String, commentId: String) -> String {
        let url = "&photo_id=\(photoId)&comment_id=\(commentId)"
        return url
    }
}
