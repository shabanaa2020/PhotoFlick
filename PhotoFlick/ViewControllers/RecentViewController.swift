//
//  RecentViewController.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 24/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

protocol RecentProtocol {
    func recentFavBtnClicked(on image: UIImage?, with tag: Int?)
}

class RecentViewController: UIViewController {

    @IBOutlet weak var recentPhotosCollectionVw: UICollectionView!
    fileprivate let viewModel = RecentViewModel()
    var recentDelegate: RecentProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        Loader.start(from: self.view)
        viewModel.requestRecentPhotos {
            print("get recent photos done = ", self.viewModel.photos.count)
            DispatchQueue.main.async(execute: {
                self.recentPhotosCollectionVw.reloadData()
                Loader.stop()
            })
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func registerNibs() {
        recentPhotosCollectionVw.register(HomeCollectionViewCell.nib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        cell.favouriteBtn.tintColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let flickrPhoto = viewModel.flickrPhoto?.photoForIndexPath(indexPath: indexPath) {
        (cell as! HomeCollectionViewCell).loadImage(with: flickrPhoto.flickrImageURL())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let home = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.detail_vc_identifier) as? DetailViewController else { return }
        home.delegate = self
        home.photoId = viewModel.photos[indexPath.row].id
        home.photoObj = viewModel.photos[indexPath.row]
        home.photoTag = indexPath.row
        self.navigationController?.pushViewController(home, animated: true)
    }
}

extension RecentViewController: UICollectionViewDelegateFlowLayout {
    
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
        let yourWidth = collectionView.bounds.width/3.0 - CGFloat(AppConstants.NumericConstants.minPadding)
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
}

extension RecentViewController: DetailViewProtocol {
    
    func favBtnClicked(on image: UIImage?, with tag: Int?) {
        self.recentDelegate?.recentFavBtnClicked(on: image, with: tag)
    }
}
