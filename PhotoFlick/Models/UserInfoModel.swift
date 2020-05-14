//
//  UserInfoModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 22/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    var user : User?
    var stat: String?
}

struct User: Codable {
    var id : String?
    var path_alias: String?
    var username: UserName?
}

struct UserName: Codable {
    var _content: String?
}
