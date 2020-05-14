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
    
    func requestUserInformation(onSuccess: @escaping(UserInfo?) -> Void, onFailure: @escaping(Error) -> Void) {
        apiResource.getUserId() { (response, error) in
            guard let err = error else {
                DataManager.user_id = response?.user?.id ?? ""
                onSuccess(response)
                return
            }
            onFailure(err)
        }
    }
}
