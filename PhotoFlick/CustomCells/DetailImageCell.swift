//
//  DetailImageCell.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

protocol DetailProtocol {
    func favsBtnClicked(on image: UIImage?, senderSelected: Bool)
}

class DetailImageCell: UITableViewCell {

    @IBOutlet weak var imageVw: ImageLoader!
    @IBOutlet weak var favBtn: UIButton!
    var delegate: DetailProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favBtn.tintColor = .red
    }
    
    func loadImage(with url: URL?) {
           if let strUrl = url {
               imageVw.loadImageWithUrl(strUrl)
           }
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favsBtnAction(_ sender: UIButton) {
        favBtn.isSelected = !favBtn.isSelected
        //UserDefaults.standard.set(sender.isSelected, forKey: "isFavouriteSaved")
        if favBtn.isSelected {
            self.delegate?.favsBtnClicked(on: imageVw.image, senderSelected: sender.isSelected)
        }else {
            self.delegate?.favsBtnClicked(on: nil, senderSelected: sender.isSelected)
        }
    }
}
