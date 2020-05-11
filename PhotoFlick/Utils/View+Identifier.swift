//
//  View+Identifier.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 16/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func addConstraints(to view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
