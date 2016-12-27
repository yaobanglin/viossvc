//
//  TourViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class TourViewController: SegmentedViewController {


    func segmentedViewControllerIdentifiers() -> [String]! {
        return [TourShareViewController.className(),SkillShareViewController.className()];
    }
    
}

