//
//  UserInfoModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 22/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct User: Codable {
    var id : String?
    var username : UserName?
    var stat: String?
}

struct UserName: Codable {
    var _content: String?
}
