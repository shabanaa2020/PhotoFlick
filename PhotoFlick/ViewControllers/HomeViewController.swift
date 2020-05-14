//
//  HomeViewController.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 15/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

enum Sections: Int {
    case publicPhotos = 0
    case favouritesPhotos = 1
    
    static let allValues = [publicPhotos, favouritesPhotos]
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var slideMenuTbl: UITableView!
    @IBOutlet weak var collectionVw: UICollectionView!
    var leftSlideMenu: UIView!
    var isMenuShowing = false
    var menuArr = [String]()
    fileprivate let viewModel = HomeViewModel()
    fileprivate let favViewModel = FavouritesViewModel()
    fileprivate var showNoFavs = false
    fileprivate var favsVC = FavouritesViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = viewModel.navigationTitle
        addBottomSheetView()

        menuArr = [AppConstants.leftMenuArray.Recents.rawValue, AppConstants.leftMenuArray.Favourites.rawValue]
        registerNibs()
        setUpMenu()
        DispatchQueue.main.async(execute: {
            Loader.start(from: self.view)
        })
        viewModel.requestAllPublicPhotos { error in
            if let err = error {
                self.presentAlertWithTitle(title: "", message: err.localizedDescription, options: "ok".localized()) { (options) in
                }
            }else {
                DispatchQueue.main.async(execute: {
                    let indexSet = IndexSet(integer: Sections.publicPhotos.rawValue)
                    self.collectionVw.reloadSections(indexSet)
                })
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slideMenuTbl.deselectRow(at: IndexPath(row: .zero, section: .zero), animated: false)
        
        if viewModel.photos.count > 0 {
            let id = UserDefaults.standard.integer(forKey: "PhotoTag")
            let dic = UserDefaults.standard.object(forKey: "isFavouriteSaved") as? Dictionary<String, Any>
            let val = dic?[viewModel.photos[id].id ?? ""] as? Bool
            viewModel.photos[id].isFaved = val
            DispatchQueue.main.async(execute: {
                self.collectionVw.reloadSections(IndexSet(integer: .zero))
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        swipeGestureViewDown()
    }
  
    @IBAction func menuAction(_ sender: Any) {
        if self.isMenuShowing {
            self.hideMenu()
        }else {
            self.showMenu()
        }
        self.view.layoutIfNeeded()
        isMenuShowing = !isMenuShowing
    }
}

private extension HomeViewController {
    
    
    func registerNibs() {
        collectionVw.register(HomeCollectionViewCell.nib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
    
    func addBottomSheetView() {
        guard let bottomSheetVC = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.favourite_vc_identifier) as? FavouritesViewController else { return }
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        favsVC = bottomSheetVC
        
        bottomSheetVC.view.layer.shadowPath = UIBezierPath(rect: bottomSheetVC.view.bounds).cgPath
        bottomSheetVC.view.layer.shadowColor = UIColor.black.cgColor
        bottomSheetVC.view.layer.shadowOpacity = Float(CGFloat(AppConstants.NumericConstants.shadowOpacity))
        bottomSheetVC.view.layer.shadowOffset = .zero
        bottomSheetVC.view.layer.shadowRadius = CGFloat(AppConstants.NumericConstants.shadowRadius)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        bottomConstraint.constant = CGFloat(AppConstants.NumericConstants.bottomSheetBottomConstraint)
    }
    
    func showMenu() {
        UIView.animate(withDuration: AppConstants.NumericConstants.animationDuration, delay: .zero, options: .curveEaseIn, animations: {
            self.leftSlideMenu.frame = CGRect(x: .zero, y: .zero, width: self.leftSlideMenu.frame.size.width, height: self.leftSlideMenu.frame.size.height)
            self.view.bringSubviewToFront(self.leftSlideMenu)
        }) { (completion) in
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: AppConstants.NumericConstants.animationDuration, delay: .zero, options: .curveEaseIn, animations: {
            self.leftSlideMenu.frame = CGRect(x: CGFloat(AppConstants.NumericConstants.leftMenuMinX), y: .zero, width: self.leftSlideMenu.frame.size.width, height: self.leftSlideMenu.frame.size.height)
        }) { (completion) in
            self.isMenuShowing = false
        }
    }
    
    func setUpMenu() {
        self.leftSlideMenu = UIView.init(frame: CGRect(x: CGFloat(AppConstants.NumericConstants.leftMenuMinX), y: .zero, width: CGFloat(AppConstants.NumericConstants.leftMenuMaxX), height: self.view.frame.height))
        self.view.addSubview(self.leftSlideMenu)
        self.leftSlideMenu.backgroundColor = UIColor.bgColor
        self.slideMenuTbl = UITableView.init(frame: self.leftSlideMenu.frame)
        self.leftSlideMenu.addSubview(self.slideMenuTbl)
        self.slideMenuTbl.backgroundColor = .clear
        self.slideMenuTbl.delegate = self
        self.slideMenuTbl.dataSource = self
        self.slideMenuTbl.tableFooterView = UIView()
        self.addConstraints(to: self.slideMenuTbl, from: self.leftSlideMenu)
    }
    
    func addConstraints(to view: UIView, from parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
    }
    
    func pushViewController() {
        guard let home = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.recent_vc_identifier) as? RecentViewController else { return }
        home.recentDelegate = self
        self.navigationController?.pushViewController(home, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(AppConstants.NumericConstants.leftMenuRowHeight)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .clear
        cell.textLabel?.text = menuArr[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(AppConstants.NumericConstants.leftMenuFontSize))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMenu()
        switch indexPath.row {
        case Sections.publicPhotos.rawValue:
            pushViewController()
        case Sections.favouritesPhotos.rawValue:
            swipeGestureViewUp()
        default:
            return
        }
    }
    
    func swipeGestureViewUp() {
        UIView.animate(withDuration: 0.3, delay: .zero, options: [.allowUserInteraction], animations: {
            self.favsVC.view.frame = CGRect(x: .zero, y: self.favsVC.fullView, width: self.favsVC.view.frame.width, height: self.favsVC.view.frame.height)
            self.favsVC.handleImg.image = UIImage(named: AppConstants.ImageNames.downArrowImg)
        }, completion: nil)
    }
    
    func swipeGestureViewDown() {
        UIView.animate(withDuration: 0.3, delay: .zero, options: [.allowUserInteraction], animations: {
            self.favsVC.view.frame = CGRect(x: .zero, y: self.favsVC.partialView, width: self.favsVC.view.frame.width, height: self.favsVC.view.frame.height)
            self.favsVC.handleImg.image = UIImage(named: AppConstants.ImageNames.upArrowImg)
        }, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
//        if viewModel.photos[indexPath.row].isfavorite == 1{
//            cell.favouriteBtn.setImage(UIImage(named: AppConstants.ImageNames.filledHeartImg), for: .normal)
//        }
        cell.favouriteBtn.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let flickrPhoto = viewModel.flickrPhoto?.photoForIndexPath(indexPath: indexPath) {
            (cell as! HomeCollectionViewCell).loadImage(with: flickrPhoto.flickrImageURL())
            if viewModel.photos[indexPath.row].isFaved ?? false {
                (cell as! HomeCollectionViewCell).favouriteBtn.setImage(UIImage(named: AppConstants.ImageNames.filledHeartImg), for: .normal)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let home = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.detail_vc_identifier) as? DetailViewController else { return }
        home.delegate = self
        home.photoId = viewModel.photos[indexPath.row].id
        home.photoObj = viewModel.photos[indexPath.row]
        home.photoTag = indexPath.row
        home.navTitle = viewModel.photos[indexPath.row].title
        self.navigationController?.pushViewController(home, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(AppConstants.NumericConstants.minLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/CGFloat(AppConstants.NumericConstants.numberOfItemsPerRow) - CGFloat(AppConstants.NumericConstants.minPadding)
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
}

extension HomeViewController: DetailViewProtocol, RecentProtocol {
    
    func recentFavBtnClicked(on image: UIImage?, with tag: Int?) {
        favsVC.onFavClicked(on: image, with: tag)
    }
    
    func favBtnClicked(on image: UIImage?, with tag: Int?) {
        favsVC.onFavClicked(on: image, with: tag)
    }
}

