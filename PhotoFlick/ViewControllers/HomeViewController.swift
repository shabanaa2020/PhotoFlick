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
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var slideMenuTbl: UITableView!
    @IBOutlet weak var collectionVw: UICollectionView!
    var leftSlideMenu: UIView!
    var isMenuShowing = false
    var menuArr = [String]()
    fileprivate let viewModel = HomeViewModel()
    fileprivate let favViewModel = FavouritesViewModel()
    fileprivate var showNoFavs = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = viewModel.navigationTitle
        menuArr = [AppConstants.leftMenuArray.Recents.rawValue, AppConstants.leftMenuArray.Favourites.rawValue]
        registerNibs()
        setUpMenu()
        DispatchQueue.main.async(execute: {
            Loader.start(from: self.view)
        })
        viewModel.requestAllPublicPhotos {
            DispatchQueue.main.async(execute: {
                let indexSet = IndexSet(integer: Sections.publicPhotos.rawValue)
                self.collectionVw.reloadSections(indexSet)
            })
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slideMenuTbl.deselectRow(at: IndexPath(row: .zero, section: .zero), animated: false)
        
        favViewModel.requestFavouritePhotos {
            DispatchQueue.main.async(execute: {
                if self.favViewModel.cdImageArray.count == 0 {
                    self.showNoFavs = true
                }
                let indexSet = IndexSet(integer: Sections.favouritesPhotos.rawValue)
                self.collectionVw.reloadSections(indexSet)
                Loader.stop()
            })
        }
        if viewModel.photos.count > 0 {
            let id = UserDefaults.standard.integer(forKey: "PhotoTag")
            let dic = UserDefaults.standard.object(forKey: "isFavouriteSaved") as? Dictionary<String, Any>
            let val = dic?[viewModel.photos[id].id ?? ""] as? Bool
            viewModel.photos[id].isFaved = val
            DispatchQueue.main.async(execute: {
                self.collectionVw.reloadSections(IndexSet(integer: 1))
            })
        }
    }
    
    private func registerNibs() {
        collectionVw.register(HomeCollectionViewCell.nib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionVw.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        collectionVw.register(SectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooterView.identifier)
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
        self.leftSlideMenu.backgroundColor = .brown
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .clear
        cell.textLabel?.text = menuArr[indexPath.row]
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMenu()
        switch indexPath.row {
        case Sections.publicPhotos.rawValue:
            pushViewController()
        case Sections.favouritesPhotos.rawValue:
            collectionVw.scrollToItem(at:IndexPath(item: .zero, section: Sections.favouritesPhotos.rawValue), at: .top, animated: true)
        default:
            return
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Sections.publicPhotos.rawValue:
            return viewModel.photos.count
        case Sections.favouritesPhotos.rawValue:
            return favViewModel.cdImageArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        switch indexPath.section {
        case Sections.publicPhotos.rawValue:
            cell.favouriteBtn.isHidden = false
            cell.favouriteBtn.tag = indexPath.row
            break
        case Sections.favouritesPhotos.rawValue:
            cell.favouriteBtn.isHidden = true
            break
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case Sections.publicPhotos.rawValue:
            if let flickrPhoto = viewModel.flickrPhoto?.photoForIndexPath(indexPath: indexPath) {
                (cell as! HomeCollectionViewCell).loadImage(with: flickrPhoto.flickrImageURL())
            }
        case Sections.favouritesPhotos.rawValue:
            (cell as! HomeCollectionViewCell).imageVw.image = favViewModel.cdImageArray[indexPath.row]
            //            if let flickrPhoto = favViewModel.flickrPhoto?.photoForIndexPath(indexPath: indexPath) {
            //                (cell as! HomeCollectionViewCell).loadImage(with: flickrPhoto.flickrImageURL())
        //            }
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let home = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.detail_vc_identifier) as? DetailViewController else { return }
        home.delegate = self
        switch indexPath.section {
        case Sections.publicPhotos.rawValue:
            home.photoId = viewModel.photos[indexPath.row].id
            home.photoObj = viewModel.photos[indexPath.row]
            home.photoTag = indexPath.row
        case Sections.favouritesPhotos.rawValue:
            home.photoId = favViewModel.photos[indexPath.row].id
            home.photoObj = favViewModel.photos[indexPath.row]
        default:
            return
        }
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView {
                if favViewModel.cdImageArray.count > 0 {
                    sectionHeader.label.text = "favsSectionTitle".localized()
                }
                return sectionHeader
            }
        case UICollectionView.elementKindSectionFooter:
            if showNoFavs {
                if let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooterView.identifier, for: indexPath) as? SectionFooterView {
                    sectionFooter.label.text = "noFavs".localized()
                    return sectionFooter
                }
            }else {
                return UICollectionReusableView()
            }
        default:
            assert(false, "Unexpected element kind")
            break
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == Sections.favouritesPhotos.rawValue {
            return CGSize(width: collectionView.frame.width, height: CGFloat(AppConstants.NumericConstants.headerHeight))
        }else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == Sections.favouritesPhotos.rawValue && showNoFavs {
            return CGSize(width: collectionView.frame.width, height: CGFloat(AppConstants.NumericConstants.footerHeight))
        }
        return CGSize.zero
    }
}

extension HomeViewController: DetailViewProtocol, RecentProtocol {
    
    func recentFavBtnClicked(on image: UIImage?, with tag: Int?) {
        onFavClicked(on: image, with: tag)
    }
    
    func favBtnClicked(on image: UIImage?, with tag: Int?) {
        onFavClicked(on: image, with: tag)
    }
    
    private func onFavClicked(on image: UIImage?, with tag: Int?) {
        var array = self.favViewModel.getImageArryaFromDB()
        if let img = image {
            array.insert(img, at: 0)
        }else {
            let index = array.indexesOf(object: image)
            array.remove(at: index.first ?? 0)
        }
        self.favViewModel.saveImageArrayToDB(imageArray: array)
    }
}

