//
//  AppUtilities.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit

class AppUtilities {
    
    static func getMainStoryBoard()  -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}


extension Array {
    
    func indexesOf<T : Equatable>(object:T) -> [Int] {
        var result: [Int] = []
        for (index,obj) in enumerated() {
            if obj as! T == object {
                result.append(index)
            }
        }
        return result
    }
}

extension NSCountedSet {
    var occurences: [(object: Any, count: Int)] { map { ($0, count(for: $0))} }
    var dictionary: [AnyHashable: Int] {
        reduce(into: [:]) {
            guard let key = $1 as? AnyHashable else { return }
            $0[key] = count(for: key)
        }
    }
}

