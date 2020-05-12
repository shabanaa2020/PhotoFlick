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
    func editBtnClicked(at index: Int)
    func deleteBtnClicked(at index: Int)
}

class CommentsCell: UITableViewCell {

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var commentsTableVw: UITableView!
    var commentsDelegate: CommentsProtocol?
    var commentsArray: [Comment]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentsTableVw.register(CommentDetailCell.nib, forCellReuseIdentifier: CommentDetailCell.identifier)
        commentsTableVw.rowHeight = UITableView.automaticDimension
        commentsTableVw.estimatedRowHeight = 62
        //        commentsTxtVw.layer.borderWidth = 1.0
        //        commentsTxtVw.layer.borderColor = UIColor.lightGray.cgColor
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(commentsArray: [Comment]?) {
        self.commentsArray = commentsArray
        if let _ = commentsArray {
            self.noDataView.isHidden = true
            self.commentsTableVw.isHidden = false
            self.contentView.layoutIfNeeded()
        }else {
            self.commentsTableVw.isHidden = true
            self.noDataView.isHidden = false
        }
    }
    
//    @IBAction func saveBtnAction(_ sender: UIButton) {
//        if commentsTxtVw.text.count != 0 {
//        self.endEditing(true)
//        let str = commentsTxtVw.text.trimmingCharacters(in: .whitespacesAndNewlines)
//        let escapedString = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        self.commentsDelegate?.saveCommentsClicked(with: escapedString)
//        }else {
//            self.commentsDelegate?.saveCommentsClicked(with: nil)
//        }
//    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.superview?.superview?.frame.origin.y == 0 {
//                self.superview?.superview?.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.superview?.superview?.frame.origin.y != 0 {
//            self.superview?.superview?.frame.origin.y = 0
//        }
//    }
    
    @IBAction func addNewCommentAction(_ sender: Any) {
        
    }
}

extension CommentsCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:CommentDetailCell.identifier) as? CommentDetailCell
        cell?.delegate = self
        cell?.editBtn.tag = indexPath.row
        cell?.deleteBtn.tag = indexPath.row
        if let item = commentsArray?[indexPath.row] {
            cell?.bindData(comment: item)
        }
        return cell ?? UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         return UITableView.automaticDimension
//    }
//    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
      
}

extension CommentsCell: CommentsDetailCellProtocol {
    
    func deleteBtnClicked(at index: Int) {
        self.commentsDelegate?.deleteBtnClicked(at: index)
    }
    
    func editBntClicked(at index: Int) {
        self.commentsDelegate?.editBtnClicked(at: index)

    }
}
