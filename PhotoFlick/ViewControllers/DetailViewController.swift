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
    var favesArray: [String]? = []
    fileprivate let viewModel = DetailViewModel()
    var delegate: DetailViewProtocol?
    var navTitle: String?
    var favCountArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        registerNibs()
        detailsTableVw.rowHeight = 300
        //detailsTableVw.estimatedRowHeight = CGFloat(AppConstants.NumericConstants.estimated_row_height)
        if let id = photoId {
            viewModel.photoId = id
            viewModel.photoObject = photoObj
        }
        viewModel.bindFlickrPhoto {
            DispatchQueue.main.async(execute: {
                let indexPath = IndexPath(row: Details.image.rawValue, section: .zero)
                self.detailsTableVw.reloadRows(at: [indexPath], with: .top)
            })
        }
        loadComments()
        viewModel.getPhotoFavourites { error in
            if let err = error {
                self.presentAlertWithTitle(title: "", message: err.localizedDescription, options: "ok".localized()) { (option) in }
            }else {
                self.processToPlotGraph()
            }
        }
    }
   
    func loadComments() {
        viewModel.getCommentsList { error in
            if let err = error {
                self.presentAlertWithTitle(title: "", message: err.localizedDescription, options: "ok".localized()) { (option) in }
            }else {
                self.reloadCommentsList()
            }
        }
    }
    
    @IBAction func addNewCommentAction(_ sender: Any) {
        addNewBtnClicked()
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
    
    func saveCommentsClicked(with comment: String?, commentId: String?, isEdit: CommentType, completion: @escaping (AddCommentResponse?) -> ()) {
        if let str = comment {
            switch isEdit {
            case .new:
                viewModel.addComments(photoId: viewModel.photoId ?? "", commentTxt: str) { (response) in
                    Loader.stop()
                    completion(response)
                }
            case .edit:
                viewModel.editComments(commentId: commentId ?? "", commentTxt: str) { (response) in
                    Loader.stop()
                    completion(response)
                }
            }
            loadComments()
        }
    }
    
    func editBtnClicked(at index: Int) {
        guard let addComments = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.addComment_vc_identifier) as? AddCommentViewController else { return }
        addComments.delegate = self
        addComments.commentModel = viewModel.commentsList?[index]
        addComments.editType = .edit
        self.navigationController?.pushViewController(addComments, animated: true)
    }
    
    func deleteBtnClicked(at index: Int) {
        Loader.start(from: self.view)
        let commentId = viewModel.commentsList?[index].id ?? ""
        viewModel.deleteComments(photoId: viewModel.photoId ?? "", commentId: commentId) { (response) in
            Loader.stop()
            self.presentAlertWithTitle(title: "success".localized(), message: "comment_delete_msg".localized(), options: "ok".localized()) { (option) in }
            if response?.stat != "fail"{
                self.viewModel.commentsList?.remove(at: index)
                self.reloadCommentsList()
            }
        }
    }
    
    func addNewBtnClicked() {
        guard let addComments = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.addComment_vc_identifier) as? AddCommentViewController else { return }
        addComments.delegate = self
        self.navigationController?.pushViewController(addComments, animated: true)
    }
}

private extension DetailViewController {
    
    func registerNibs() {
        detailsTableVw.register(DetailImageCell.nib, forCellReuseIdentifier: DetailImageCell.identifier)
        detailsTableVw.register(GraphCell.nib, forCellReuseIdentifier: GraphCell.identifier)
        detailsTableVw.register(CommentsCell.nib, forCellReuseIdentifier: CommentsCell.identifier)
    }
    
    func processToPlotGraph() {
        var array = [Person]()
        array = self.viewModel.photoFavs?.photo?.person ?? []
        let dates = array.map {$0.favedate?.stringFromTimestamp()}
        let values = dates
        var countedDates = [String?]()
        let countedSet = NSCountedSet(array: values as [Any])
        for (key, value) in countedSet.dictionary {
            print("Element:", key, "count:", value)
            self.viewModel.favesCountArray.append(String(value)) // data point array to be plotted on graph
            countedDates.append(key as? String)
        }
        
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = AppConstants.GeneralConstants.dateFormat
        var sortedDates = countedDates.sorted { isoFormatter.date(from: $0 ?? "")! > isoFormatter.date(from: $1 ?? "") ?? Date() }
        print(sortedDates)
        sortedDates = sortedDates.reversed() // Dates Array to be plotted on x axis
        self.viewModel.datesArr = sortedDates
        
        DispatchQueue.main.async(execute: {
            let indexPath = IndexPath(row: Details.graph.rawValue, section: .zero)
            self.detailsTableVw.reloadRows(at: [indexPath], with: .none)
        })
    }
    
    func addFav() {
        viewModel.addFavourite(photoId: viewModel.photoId ?? "") { (response) in
            self.showMessage(response: response)
        }
    }
    
    func removeFav() {
        viewModel.removeFavourite(photoId: viewModel.photoId ?? "") { (response) in
            self.showMessage(response: response)
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
        return AppConstants.NumericConstants.numberOfItemsPerRow
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//    }
    
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
                graphCell?.configureChart(dateArray: viewModel.datesArr as! [String], favsArray: viewModel.favesCountArray as? [String])
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

