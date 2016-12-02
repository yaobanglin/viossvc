//
//  HomeViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation


class HomeViewController: SegmentedViewController {
    
    
    
    func segmentedViewControllerIdentifiers() -> [String]! {
        return [ChatListViewController.className(),OrderListViewController.className()];
    }

    
    
}
