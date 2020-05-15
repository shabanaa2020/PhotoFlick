//
//  Result.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 27/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation

enum Result<T, E> where E: Error {
    case success(T)
    case failure(E)
}
