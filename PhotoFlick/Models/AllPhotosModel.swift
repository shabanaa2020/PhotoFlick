//
//  FavouritePhotosModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 22/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct AllPhotos: Codable {
    var photos : Photos?
    var stat : String?
}

struct Photos: Codable {
    let page : Int?
    let pages : Int?
    let perpage : Int?
    let per_page: Int?
    let total : String?
    let photo : [Photo]?
}

struct Photo: Codable {
    let id : String?
    let owner : String?
    let secret : String?
    let server : String?
    let farm : Int?
    let title : String?
    let ispublic : Int?
    let isfriend : Int?
    let isfamily : Int?
    let date_faved: String?
    let username: String?
    var isFaved: Bool?
}
