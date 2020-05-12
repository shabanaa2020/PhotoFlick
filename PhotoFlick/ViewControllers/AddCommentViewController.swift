//
//  AddCommentViewController.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 12/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

protocol AddCommentsProtocol {
    func saveCommentsClicked(with comment: String?, completion:@escaping (AddFavourite?) -> ())
}

class AddCommentViewController: UIViewController {
    
    @IBOutlet var textVw: UITextView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var saveBtn: UIButton!
    var delegate: AddCommentsProtocol?
    var textViewText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textVw.layer.borderWidth = 1.0
        textVw.layer.borderColor = UIColor.lightGray.cgColor
        textVw.textContainerInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        self.navigationController?.navigationItem.title = "addCommentTitle".localized()
        if let str = textViewText {
        textVw.text = str
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        Loader.start(from: view)
        let trimmedString = textVw.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.count != 0 {
            self.view.endEditing(true)
            let escapedString = trimmedString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            self.delegate?.saveCommentsClicked(with: escapedString, completion: { response in
                Loader.stop()
                if response?.stat == "fail" {
                    self.presentAlertWithTitle(title: response?.stat ?? "", message: response?.message ?? "", options: "ok".localized()) { (option) in
                    }
                }else {
                    self.presentAlertWithTitle(title: response?.stat ?? "", message: response?.message ?? "", options: "ok".localized()) { (option) in
                        switch option{
                        case 0:
                            self.navigationController?.popViewController(animated: true)
                            break
                        default:
                            break
                        }
                    }
                }
            })
        }else {
            self.presentAlertWithTitle(title: "error".localized(), message: "emptyComments".localized(), options: "ok".localized()) { (option) in
            }
        }
    }
}
