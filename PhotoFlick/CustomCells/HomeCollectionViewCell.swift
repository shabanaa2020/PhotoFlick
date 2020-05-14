//
//  HomeCollectionViewCell.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 16/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

enum cellType {
    case publicPhotos
    case favouritePhotos
}

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageVw: ImageLoader!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadImage(with url: URL?) {
        if let strUrl = url {
            imageVw.loadImageWithUrl(strUrl)
        }
    }
}
