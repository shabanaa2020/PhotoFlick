//
//  LoginViewModel.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit

class LoginViewModel {
    
    let authorize: Authorize
    let apiResource: ApiResource
    
    init() {
        authorize = Authorize()
        apiResource = ApiResource(method: HTTPNetworkRoute.testLogin.rawValue, userId: nil)
    }
    
    func requestAuthorization(vc: UIViewController, completion:@escaping (Error?) -> ()) {
        authorize.authenticate(vc: vc) { (access_token, error) in
            if let token = access_token {
                DataManager.access_token = token
                completion(nil)
            }
            if let error = error {
                completion(error)
            }
        }
    }
    
    func requestUserInformation(onSuccess: @escaping(String) -> Void, onFailure: @escaping(Error) -> Void) {
//        apiResource.getRequest{ (data, error) in
//            do {
//                let json = try JSONDecoder().decode(User.self, from: data ?? Data())
////                if json.stat == "fail" {
////                    onFailure(error!)
////                }
//                DataManager.user_id = json.id ?? ""
//                DataManager.user_name = json.username?._content ?? ""
//                onSuccess("")
//            } catch {
//                onFailure(error)
//            }
//        }
    }
}
