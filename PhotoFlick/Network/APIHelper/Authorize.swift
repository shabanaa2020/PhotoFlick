//
//  Authorize.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import OAuthSwift
import SafariServices

class Authorize {
    
    var validation = Validation()
    var oauthswift: OAuthSwift?

    func authenticate(vc: UIViewController, completion:@escaping (String?, Error?) -> ()) {
        let oauthswift = OAuth1Swift(
            consumerKey:   ApiConstants.shared.apiKey,
            consumerSecret: ApiConstants.shared.apiSecret,
            requestTokenUrl: "\(ApiConstants.shared.OAuthBaseUrl)/request_token",
            authorizeUrl:    "\(ApiConstants.shared.OAuthBaseUrl)/authorize", //?perms=write
            accessTokenUrl:  "\(ApiConstants.shared.OAuthBaseUrl)/access_token"
        )
        
        self.oauthswift = oauthswift
        let handler = SafariURLHandler(viewController: vc, oauthSwift: self.oauthswift!)
        handler.delegate = vc as? SFSafariViewControllerDelegate
        handler.presentCompletion = {
            print("Safari presented")
        }
        handler.dismissCompletion = {
            print("Safari dismissed")
        }
        handler.factory = { url in
            let controller = SFSafariViewController(url: url)
            return controller
        }
        oauthswift.authorizeURLHandler = handler
        let _ = oauthswift.authorize(
        withCallbackURL: URL(string: ApiConstants.shared.OAuthCallBackUrl)!) { result in
            switch result {
            case .success(let (credential, _, _)):
                debugPrint("token = \(credential.oauthToken)")
                OauthService.shared.oauthswift = oauthswift
                completion(credential.oauthToken, nil)
                DataManager.access_token = credential.oauthToken
            case .failure(let error):
                print(error.description)
                completion(nil, error)
            }
        }
    }
}

