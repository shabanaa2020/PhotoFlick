//
//  ApiConstants.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 20/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

final class ApiConstants: NSObject {
    
    // MARK: - Shared Instance
    
    static let shared = ApiConstants()
    
    // MARK: - Local Variable
    
    let apiKey: String
    let apiSecret: String
    let OAuthBaseUrl: String
    let OAuthCallBackUrl: String
    let baseUrl: String
    let format: String
    
    // MARK: - Lifecycle
    override init() {
        guard let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") else {
            fatalError("NO configuration file added..")
        }
        
        guard let configDictionary = NSDictionary(contentsOfFile: path) else {
            fatalError("Something went wrong when loading configurion file..")
        }
        
        guard let apiKey = configDictionary["apiKey"] as? String,
            let apiSecret = configDictionary["apiSecret"] as? String,
            let OAuthBaseUrl = configDictionary["OAuthBaseUrl"] as? String,
            let OAuthCallBackUrl = configDictionary["OAuthCallBackUrl"] as? String else {
                fatalError("Something went wrong when loading apiKey/apiSecret..")
                
        }
        
        guard let baseUrl = configDictionary["apiBase"] as? String else {
            fatalError("Something went wrong...")
        }
        
        guard let format = configDictionary["apiFormat"] as? String else {
            fatalError("Something went wrong...")
        }
            
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.OAuthBaseUrl = OAuthBaseUrl
        self.OAuthCallBackUrl = OAuthCallBackUrl
        self.baseUrl = baseUrl
        self.format = format
    }
    
}
