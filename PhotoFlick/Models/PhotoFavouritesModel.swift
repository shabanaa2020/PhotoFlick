//
//  PhotoFavouritesModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 13/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct PhotoFavourites: Codable {
    let photo: FavPhoto?
    let stat: String?
}

struct FavPhoto: Codable {
    let person: [Person]?
    let id: String?
    let secret: String?
    let server: String?
    let farm, page, pages, perpage: Int?
    let total: String?
}

struct Person: Codable {
    let nsid: String?
    let username: String?
    let realname: String?
    let favedate: String?
    let iconserver: String?
    let iconfarm, contact, friend, family: Int?
    var count_faves: Int?
}
