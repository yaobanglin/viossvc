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
        return [ChatSessionViewController.className(),OrderListViewController.className()];
    }


    
    @IBAction func refreshServiceAction(sender: AnyObject) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let refreshServiceVC = storyBoard.instantiateViewControllerWithIdentifier("SMSServerViewController")
        
        navigationController?.pushViewController(refreshServiceVC, animated: true)
    }

    //友盟页面统计
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(HomeViewController.className())
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(HomeViewController.className())
    }
}
