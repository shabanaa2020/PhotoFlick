//
//  PostCommentResponseModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 15/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct AddCommentResponse: Codable {
    let comment: CommentDetails?
    let stat: String?
}

struct CommentDetails: Codable {
    let _content: String?
    let author: String?
    let authorname: String?
    let datecreate: String?
    let iconurls: IconUrls?
    let id: String?
    let path_alias: String?
    let permalink: String?
    let realname: String?
}

struct IconUrls: Codable {
    let `default`: String?
    let large: String?
    let medium: String?
    let retina: String?
    let small: String?
}
