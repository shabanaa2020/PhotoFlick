//
//  CommentsCell.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

protocol CommentsProtocol {
    func editBtnClicked(at index: Int)
    func deleteBtnClicked(at index: Int)
    func addNewBtnClicked()
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
    
    @IBAction func addNewComment(_ sender: UIButton) {
        self.commentsDelegate?.addNewBtnClicked()
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
