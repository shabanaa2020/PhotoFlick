//
//  ActivityIndicatorView.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit

final class Loader {
    
    fileprivate static var activityIndicator: UIActivityIndicatorView?
    fileprivate static var style: UIActivityIndicatorView.Style = .large
    fileprivate static var baseBackColor = UIColor(white: 0, alpha: 0.6)
    fileprivate static var baseColor = UIColor.white
    
    /**
     Add loader to `UIView`
     - Parameters:
     - view: The `UIView` being used to add the `UIActivityIndicatorView` onto
     - style: Style used for the `UIActivityIndicatorView`
     - backgroundColor: Display color
     - baseColor: Tint color of the loader
     */
    public static func start(from view: UIView) {
        
        guard Loader.activityIndicator == nil else { return }
        
        let loader = UIActivityIndicatorView(style: style)
        loader.backgroundColor = baseBackColor
        loader.color = baseColor
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        
        // Auto-layout constraints
        addConstraints(to: view, with: loader)
        
        Loader.activityIndicator = loader
        DispatchQueue.main.async(execute: {
        Loader.activityIndicator?.startAnimating()
        })
    }
    
    /// Stops and removes `UIActivityIndicatorView`
    public static func stop() {
        DispatchQueue.main.async(execute: {
        Loader.activityIndicator?.stopAnimating()
        Loader.activityIndicator?.removeFromSuperview()
        Loader.activityIndicator = nil
        })
    }
    
    /**
     Add auto-layout constraints to provided `UIActivityIndicatorView`
     - Parameters:
     - view: The view used to provide layout constraints
     - loader: The `UIActivityIndicatorView` used to display
     */
    fileprivate static func addConstraints(to view: UIView, with loader: UIActivityIndicatorView) {
        loader.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loader.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loader.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loader.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}
