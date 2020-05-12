//
//  CommentsModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 11/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct CommentsList: Codable {
    var comments: List?
    var stat: String?
}

struct List: Codable {
    var photo_id: String?
    var comment: [Comment]?
}

struct Comment: Codable {
    var id: String?
    var author: String?
    var author_is_deleted: Int?
    var authorname: String?
    var iconserver: String?
    var iconfarm: Int?
    var datecreate: String?
    var permalink: String?
    var path_alias: String?
    var realname: String?
    var _content: String?
}
