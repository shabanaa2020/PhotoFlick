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

class ViewController: UIViewController {

    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var stackVw: UIStackView!
    @IBOutlet weak var userNameTf: CustomTextField!
    @IBOutlet weak var passwordTf: CustomTextField!
    @IBOutlet weak var loginBtn: CustomButton!
    var validation = Validation()
    var oauthswift: OAuthSwift?
    fileprivate let viewModel = LoginViewModel()
    
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

//MARK:- Login Click
    @IBAction func onLoginAction(_ sender: Any) {
        resignFirstResponder()
        Loader.start(from: self.view)
        if validateFields() {
            viewModel.requestAuthorization(vc: self) { (error) in
                if let err = error {
                    print(err)
                }else {
                    self.updateViewOnLoginSucess()
//                    self.viewModel.requestUserInformation(onSuccess: {
//                        self.updateViewOnLoginSucess()
//                    }) { (error) in
//                        // TODO: Show alert for error
//                    }
                }
            }
        }
    }
    
// MARK:- Keyboard actions
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
}

//MARK:- SafariViewController Delegate Method
extension ViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        Loader.stop()
    }
}

// MARK:- Private Methods
private extension ViewController {
    
    func updateViewOnLoginSucess() {
           Loader.stop()
           guard let home = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.home_vc_identifier) as? HomeViewController else { return }
           self.navigationController?.pushViewController(home, animated: true)
       }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
       
    func removeObservers() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
    func resignResponder() {
           userNameTf.resignFirstResponder()
           passwordTf.resignFirstResponder()
       }
    
    func validateFields() -> Bool {
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
    
    func showErrorLable(errorMsg: String) {
        errorLbl.isHidden = false
        errorLbl.text = errorMsg
    }
    
    func hideErrorLable() {
        errorLbl.isHidden = true
        
    }
}
