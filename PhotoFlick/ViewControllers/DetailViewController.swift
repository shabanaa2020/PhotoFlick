//
//  DetailViewController.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 20/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

enum Details: Int {
    case image = 0
    case graph = 1
    case comments = 2
}

protocol DetailViewProtocol {
    func favBtnClicked(on image: UIImage?, with tag: Int?)
}

class DetailViewController: UIViewController {
   
    @IBOutlet weak var detailsTableVw: UITableView!
    var photoId: String?
    var photoObj: Photo?
    var photoTag: Int?
    fileprivate let viewModel = DetailViewModel()
    var delegate: DetailViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel.navigationTitle
        registerNibs()
        detailsTableVw.rowHeight = UITableView.automaticDimension
        detailsTableVw.estimatedRowHeight = CGFloat(AppConstants.NumericConstants.estimated_row_height)
        if let id = photoId {
            viewModel.photoId = id
            viewModel.photoObject = photoObj
        }
        viewModel.bindFlickrPhoto {
            DispatchQueue.main.async(execute: {
            let indexPath = IndexPath(row: 0, section: 0)
            self.detailsTableVw.reloadRows(at: [indexPath], with: .top)
            })
        }
        viewModel.getCommentsList {
            self.reloadCommentsList()
        }
        // Do any additional setup after loading the view.
    }
}

extension DetailViewController: DetailProtocol, CommentsProtocol, AddCommentsProtocol {
    
    func favsBtnClicked(on image: UIImage?, senderSelected: Bool) {
        Loader.start(from: self.view)
        if let img = image {
            self.delegate?.favBtnClicked(on: img, with: photoTag)
            addFav()
        }else {
            self.delegate?.favBtnClicked(on: nil, with: photoTag)
            removeFav()
        }
        let dict = [viewModel.photoObject?.id: true]
        UserDefaults.standard.set(dict, forKey: "isFavouriteSaved")
        UserDefaults.standard.set(photoTag, forKey: "PhotoTag")
        viewModel.photoObject?.isFaved = senderSelected
        detailsTableVw.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func saveCommentsClicked(with comment: String?, completion: @escaping (AddFavourite?) -> ()) {
        if let str = comment {
            Loader.start(from: self.view)
            viewModel.addComments(photoId: viewModel.photoId ?? "", commentTxt: str) { (response) in
                Loader.stop()
                completion(response)
            }
        }
    }
    
    func editBtnClicked(at index: Int) {
        guard let addComments = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.addComment_vc_identifier) as? AddCommentViewController else { return }
        addComments.delegate = self
        addComments.textViewText = viewModel.commentsList?[index]._content
        self.navigationController?.pushViewController(addComments, animated: true)
    }
    
    func deleteBtnClicked(at index: Int) {
        let commentId = viewModel.commentsList?[index].id ?? ""
        viewModel.deleteComments(photoId: viewModel.photoId ?? "", commentId: commentId) { (response) in
            Loader.stop()
            self.presentAlertWithTitle(title: response?.stat ?? "", message: response?.message ?? "", options: "OK") { (option) in
            }
            if response?.stat != "fail"{
                self.viewModel.commentsList?.remove(at: index)
                self.reloadCommentsList()
            }
        }
    }
}

private extension DetailViewController {
    
    func registerNibs() {
        detailsTableVw.register(DetailImageCell.nib, forCellReuseIdentifier: DetailImageCell.identifier)
        detailsTableVw.register(GraphCell.nib, forCellReuseIdentifier: GraphCell.identifier)
        detailsTableVw.register(CommentsCell.nib, forCellReuseIdentifier: CommentsCell.identifier)
    }
    
    func addFav() {
        viewModel.addFavourite(photoId: viewModel.photoId ?? "") { (response) in
            Loader.stop()
            self.presentAlertWithTitle(title: response?.stat ?? "", message: response?.message ?? "", options: "OK") { (option) in
            }
        }
    }
    
    func removeFav() {
        viewModel.removeFavourite(photoId: viewModel.photoId ?? "") { (response) in
            Loader.stop()
            self.presentAlertWithTitle(title: response?.stat ?? "", message: response?.message ?? "", options: "OK") { (option) in
            }
        }
    }
    
    func reloadCommentsList() {
        DispatchQueue.main.async(execute: {
            let indexPath = IndexPath(row: Details.comments.rawValue, section: .zero)
            self.detailsTableVw.reloadRows(at: [indexPath], with: .automatic)
        })
    }
}

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Details.image.rawValue:
            let imageCell = tableView.dequeueReusableCell(withIdentifier:DetailImageCell.identifier) as? DetailImageCell
            imageCell?.delegate = self
            imageCell?.favBtn.tag = indexPath.row
            imageCell?.favBtn.isSelected = viewModel.photoObject?.isFaved ?? false
            imageCell?.favBtn.tintColor = .red
            imageCell?.loadImage(with: viewModel.photoUrl?.flickrImageURL())
            return imageCell!
        case Details.graph.rawValue:
            let graphCell = tableView.dequeueReusableCell(withIdentifier:GraphCell.identifier) as? GraphCell
            return graphCell!
        case Details.comments.rawValue:
            let commentsCell = tableView.dequeueReusableCell(withIdentifier:CommentsCell.identifier) as? CommentsCell
            commentsCell?.bindData(commentsArray: viewModel.commentsList)
            commentsCell?.commentsDelegate = self
            return commentsCell!
        default:
            return UITableViewCell()
        }
    }
}
