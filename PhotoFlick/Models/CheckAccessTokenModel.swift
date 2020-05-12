//
//  CheckAccessTokenModel.swift
//  PhotoFlick
//
//  Created by Prakashini Pattabiraman on 12/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

struct CheckAccessTokenModel: Codable {
    let token: String?
    let perms: String?
    let user: User?
    let message: String?
    let stat: String?
    let code: Int?
}
