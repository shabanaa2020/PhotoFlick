//
//  CommentDetailCell.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 11/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

protocol CommentsDetailCellProtocol {
    func deleteBtnClicked(at index: Int)
    func editBntClicked(at index: Int)
}

class CommentDetailCell: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var textLbl: UILabel!
    var delegate: CommentsDetailCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(comment: Comment) {
        textLbl.text = comment._content
        self.contentView.layoutIfNeeded()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.delegate?.deleteBtnClicked(at: sender.tag)
    }
    
    
    @IBAction func editAction(_ sender: UIButton) {
        self.delegate?.editBntClicked(at: sender.tag)
    }
}
