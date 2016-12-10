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
    
    //友盟页面统计
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(TourViewController.className())
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(TourViewController.className())
    }
}

