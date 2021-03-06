//
//  Constants.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 21/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import Foundation
import UIKit


public struct AppConstants {
    
    struct StoryBoardIdentifiers {
        static let home_vc_identifier = "HomeViewController"
        static let detail_vc_identifier = "DetailViewController"
        static let recent_vc_identifier = "RecentViewController"
        static let favourite_vc_identifier = "FavouritesViewController"
        static let addComment_vc_identifier = "AddCommentViewController"
    }
    
    struct NumericConstants {
        static let public_section = 0
        static let favourite_section = 1
        static let cellHeight = 60
        static let minLineSpacing = 8
        static let minPadding = 5
        static let numberOfItemsPerRow = 3
        static let estimated_row_height = 400
        static let headerHeight = 60
        static let footerHeight = 100
        static let leftMenuMinX = -240
        static let leftMenuMaxX = 240
        static let animationDuration = 0.3
        static let shadowRadius = 10
        static let bottomSheetBottomConstraint = 240
        static let shadowOpacity = 1
        static let leftMenuRowHeight = 50
        static let leftMenuFontSize = 18
        static let graphPadding = 25
        static let maxFavsToFetch = 50
    }
    
    struct GeneralConstants {
        static let home_navigation_title = "HOME"
        static let recent_navigation_title = "RECENTS"
        static let graphColor = "#fe117c"
        static let dateFormat = "dd/MM/yyyy"
    }
    
    enum leftMenuArray: String {
        case Recents = "Recents"
        case Favourites = "Favourites"
    }
    
    struct ImageNames {
        static let upArrowImg = "arrow_up"
        static let downArrowImg = "arrow_down"
        static let emptyHeartImg = "like_empty"
        static let filledHeartImg = "like_full"
    }
}
