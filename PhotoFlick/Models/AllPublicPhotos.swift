//
//  AllPublicPhotos.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 13/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct AllPublicPhotos: Codable {
    var photos : PubPhotos?
    var stat : String?
}

struct PubPhotos: Codable {
    let page : Int?
    let pages : Int?
    let per_page: Int?
    let total : Int?
    let photo : [Photo]?
}
