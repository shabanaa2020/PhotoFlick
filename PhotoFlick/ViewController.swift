//
//  ViewController.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 15/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit
import OAuthSwift
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var stackVw: UIStackView!
    @IBOutlet weak var userNameTf: CustomTextField!
    @IBOutlet weak var passwordTf: CustomTextField!
    @IBOutlet weak var loginBtn: CustomButton!
    var validation = Validation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.isHidden = true
        addObservers()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       removeObservers()
    }
    
    func authenticate() {
        
        // create an instance and retain it
//        let oauthswift = OAuth1Swift(
//            consumerKey:    "1159067c8d72fb59a1664a54b8e16f1d",
//            consumerSecret: "65ead63c79c0bfc9",
//            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
//            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
//            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
//        )
//        // authorize
//        let handle = oauthswift.authorize(
//            withCallbackURL: URL(string: "PhotoFlick://oauth-callback/flickr")!) { result in
//            switch result {
//            case .success(let (credential, response, parameters)):
//              print(credential.oauthToken)
//              print(credential.oauthTokenSecret)
//              print(parameters["user_id"])
//              // Do your request
//            case .failure(let error):
//              print(error.localizedDescription)
//            }
//        }
//
        
        // create an instance and retain it
       let oauthswift = OAuth2Swift(
            consumerKey:    "f7f218a47e08fb84d3f5fb63cd540e9a",
            consumerSecret: "d83954828dc4684e",
            authorizeUrl:   "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            responseType:   "token"
        )
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.flickr.com/services/oauth/authorize")! as URL)
        safariVC.delegate = self
        self.present(safariVC, animated: true, completion: nil)
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: safariVC, oauthSwift: oauthswift)

//        let handle = oauthswift.authorize(
//            withCallbackURL: URL(string: "PhotoFlick://oauth-callback/flickr")!,
//            scope: "likes+comments", state:"flickr") { result in
//            switch result {
//            case .success(let (credential, response, parameters)):
//              print(credential.oauthToken)
//              // Do your request
//            case .failure(let error):
//              print(error.localizedDescription)
//            }
//        }
    }

    @IBAction func onLoginAction(_ sender: Any) {
        resignFirstResponder()
        if validateFields() {
            authenticate()
//            guard let home = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
//            self.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func resignResponder() {
        userNameTf.resignFirstResponder()
        passwordTf.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func validateFields() -> Bool {
        guard let email = userNameTf.text, let _ = passwordTf.text else {
            return false
        }
        if validation.isEmpty(textField: userNameTf) || validation.isEmpty(textField: passwordTf) {
            showErrorLable(errorMsg: NSLocalizedString("emptyFieldsMessage", comment: ""))
            return false
        }
        let isValidateEmail = self.validation.validateEmailId(emailID: email)
        if isValidateEmail == false {
            showErrorLable(errorMsg: NSLocalizedString("emailErrorMessage", comment: ""))
            return false
        }
        hideErrorLable()
        return true
    }
    
    private func showErrorLable(errorMsg: String) {
        errorLbl.isHidden = false
        errorLbl.text = errorMsg
    }
    
    private func hideErrorLable() {
        errorLbl.isHidden = true
        
    }
}

