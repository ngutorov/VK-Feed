//
//  Constants.swift
//  VK Feed
//
//  Created by Nikolay Gutorov on 4/9/21.
//  Copyright © 2021 Nikolay Gutorov. All rights reserved.
//

import UIKit

struct Constants {
    static let cardViewInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    static let topViewHeight: CGFloat = 36
    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHeight: CGFloat = 44
    
    static let bottomViewCardWidth: CGFloat = 80
    static let bottomViewCardHeight: CGFloat = 44
    
    static let bottomViewCardIconWidth: CGFloat = 24
    static let bottomViewCardIconHeight: CGFloat = 22
    
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 6
    
    static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    static let moreTextButtonSize = CGSize(width: 170, height: 30)
}
