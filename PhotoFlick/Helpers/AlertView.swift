//
//  AlertView.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 05/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        
        DispatchQueue.main.async(execute: {
        self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func showMessage(response: AddFavourite?) {
        Loader.stop()
        var msg = String()
        var title = String()
        if response?.stat == "fail"{
            title = response?.stat ?? ""
            msg = response?.message ?? ""
        }else {
            msg = "fav_success_msg".localized()
            title = "fav_success_title".localized()
        }
        self.presentAlertWithTitle(title: title, message: msg, options: "ok".localized()) { (option) in
        }
    }
}
