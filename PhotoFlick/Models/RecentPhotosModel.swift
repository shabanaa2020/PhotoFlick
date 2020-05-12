//
//  RecentPhotosModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 09/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct RecentPhotos: Codable {
    var photos : RecPhotos?
    var stat : String?
}

struct RecPhotos: Codable {
    let page : Int?
    let pages : Int?
    let perpage : Int?
    let total : Int?
    let photo : [Photo]?
}
