//
//  HomeViewController.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 15/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

enum Sections: Int {
    case recents = 0
    case favourites = 1
}

class HomeViewController: UIViewController {

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var slideMenuTbl: UITableView!
    @IBOutlet weak var collectionVw: UICollectionView!
    var leftSlideMenu: UIView!
    var isMenuShowing = false
    var menuArr = ["Recents", "Favourites"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "HOME"
        registerNibs()
        setUpMenu()
        // Do any additional setup after loading the view.
    }
    
     private func registerNibs() {
        collectionVw.register(HomeCollectionViewCell.nib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionVw.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
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
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.leftSlideMenu.frame = CGRect(x: 0, y: 0, width: self.leftSlideMenu.frame.size.width, height: self.leftSlideMenu.frame.size.height)
            self.view.bringSubviewToFront(self.leftSlideMenu)
        }) { (completion) in
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.leftSlideMenu.frame = CGRect(x: -240, y: 0, width: self.leftSlideMenu.frame.size.width, height: self.leftSlideMenu.frame.size.height)
        }) { (completion) in
            self.isMenuShowing = false
        }
    }
    
    func setUpMenu() {
        self.leftSlideMenu = UIView.init(frame: CGRect(x: -240, y: 0, width: 240, height: self.view.frame.height))
        self.view.addSubview(self.leftSlideMenu)
        self.leftSlideMenu.backgroundColor = .brown
        self.slideMenuTbl = UITableView.init(frame: self.leftSlideMenu.frame)
        self.leftSlideMenu.addSubview(self.slideMenuTbl)
        self.slideMenuTbl.backgroundColor = .clear
        self.slideMenuTbl.delegate = self
        self.slideMenuTbl.dataSource = self
        self.slideMenuTbl.tableFooterView = UIView()
        self.addConstraints(to: self.slideMenuTbl)
    }
    
    func addConstraints(to view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.leftSlideMenu.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.leftSlideMenu.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftSlideMenu.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: self.leftSlideMenu.rightAnchor).isActive = true
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
        case Sections.recents.rawValue:
            collectionVw.scrollToItem(at:IndexPath(item: 0, section: 0), at: .top, animated: true)
        case Sections.favourites.rawValue:
            collectionVw.scrollToItem(at:IndexPath(item: 0, section: 1), at: .top, animated: true)
        default:
            return
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Sections.recents.rawValue:
            return 12
        case Sections.favourites.rawValue:
            return 10
        default:
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0 - 5
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView {
                return sectionHeader
            }
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 60)
        }else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let home = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        self.navigationController?.pushViewController(home, animated: true)
    }
    
}
