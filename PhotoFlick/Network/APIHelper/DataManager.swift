//
//  DataManager.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation


struct DataManager {
    
    static let kAccess_token = "access_token"
    static let kUser_id = "user_id"
    static let kUser_name = "user_name"

    static var access_token: String {
        get {
            return UserDefaults.standard.string(forKey: kAccess_token) ?? ""
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: kAccess_token)
        }
    }
    
    static var user_id: String {
        get {
            return UserDefaults.standard.string(forKey: kUser_id) ?? ""
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: kUser_id)
        }
    }
    
    static var user_name: String {
        get {
            return UserDefaults.standard.string(forKey: kUser_name) ?? ""
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: kUser_name)
        }
    }
}
