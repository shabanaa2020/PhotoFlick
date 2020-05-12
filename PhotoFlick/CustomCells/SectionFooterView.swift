//
//  SectionFooterView.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 08/05/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

class SectionFooterView: UICollectionReusableView {
    
    let label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.backgroundColor = .clear
        //label.text = "noFavs".localized()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addConstraints(to: label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
