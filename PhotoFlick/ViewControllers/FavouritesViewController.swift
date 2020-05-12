//
//  FavouritesViewController.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 11/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var handleImg: UIImageView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var collectionVw: UICollectionView!
    fileprivate let favViewModel = FavouritesViewModel()
    fileprivate var showNoFavs = false
    var statusBarHeight: CGFloat = 0
    let fullView: CGFloat = 150
    var partialView: CGFloat {
        if #available(iOS 13.0, *) {
            statusBarHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return UIScreen.main.bounds.height - (200 + statusBarHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGesture))
        view.addGestureRecognizer(gesture)
        registerNibs()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
        favViewModel.requestFavouritePhotos {
            DispatchQueue.main.async(execute: {
                if self.favViewModel.cdImageArray.count == 0 {
                    self.showNoFavs = true
                }
                let indexSet = IndexSet(integer: 0)
                self.collectionVw.reloadSections(indexSet)
                Loader.stop()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    self.handleImg.image = UIImage(named: "arrow_up")
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    self.handleImg.image = UIImage(named: "arrow_down")
                }
                
            }, completion: nil)
        }
    }

    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .extraLight)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    func onFavClicked(on image: UIImage?, with tag: Int?) {
        var array = self.favViewModel.getImageArryaFromDB()
        if let img = image {
            array.insert(img, at: 0)
        }else {
            let index = array.indexesOf(object: image)
            array.remove(at: index.first ?? 0)
        }
        self.favViewModel.saveImageArrayToDB(imageArray: array)
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

private extension FavouritesViewController {
    
    func registerNibs() {
           collectionVw.register(HomeCollectionViewCell.nib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
           collectionVw.register(SectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooterView.identifier)
       }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favViewModel.cdImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        cell.favouriteBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! HomeCollectionViewCell).imageVw.image = favViewModel.cdImageArray[indexPath.row]
        if favViewModel.cdImageArray.count > 0 {
            headerLbl.text = "favsSectionTitle".localized()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let home = AppUtilities.getMainStoryBoard().instantiateViewController(withIdentifier: AppConstants.StoryBoardIdentifiers.detail_vc_identifier) as? DetailViewController else { return }
        home.photoId = favViewModel.photos[indexPath.row].id
        home.photoObj = favViewModel.photos[indexPath.row]
        self.navigationController?.pushViewController(home, animated: true)
    }
}

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    
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
//        case UICollectionView.elementKindSectionHeader:
//            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView {
//                if favViewModel.cdImageArray.count > 0 {
//                    sectionHeader.label.text = "favsSectionTitle".localized()
//                }
//                return sectionHeader
//            }
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: CGFloat(AppConstants.NumericConstants.headerHeight))
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == Sections.favouritesPhotos.rawValue && showNoFavs {
            return CGSize(width: collectionView.frame.width, height: CGFloat(AppConstants.NumericConstants.footerHeight))
        }
        return CGSize.zero
    }
}
