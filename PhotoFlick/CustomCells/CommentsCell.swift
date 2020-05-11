//
//  CommentsCell.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

protocol CommentsProtocol {
    func saveCommentsClicked(with comment: String?)
}

class CommentsCell: UITableViewCell {

    @IBOutlet weak var commentsTxtVw: UITextView!
    var commentsDelegate: CommentsProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentsTxtVw.layer.borderWidth = 1.0
        commentsTxtVw.layer.borderColor = UIColor.lightGray.cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        if commentsTxtVw.text.count != 0 {
        self.endEditing(true)
        let str = commentsTxtVw.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let escapedString = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        self.commentsDelegate?.saveCommentsClicked(with: escapedString)
        }else {
            self.commentsDelegate?.saveCommentsClicked(with: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.superview?.superview?.frame.origin.y == 0 {
                self.superview?.superview?.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.superview?.superview?.frame.origin.y != 0 {
            self.superview?.superview?.frame.origin.y = 0
        }
    }
}
