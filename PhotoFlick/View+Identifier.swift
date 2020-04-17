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
}
