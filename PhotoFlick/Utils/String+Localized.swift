//
//  String+Localized.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 15/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    
    func dateFromTimestamp() -> Date {
        if self.isEmpty {
            return Date()
        }
        let time = (self as NSString).doubleValue
        return Date(timeIntervalSince1970: time)
    }
    
    func stringFromTimestamp() -> String {
        let date = self.dateFromTimestamp()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
