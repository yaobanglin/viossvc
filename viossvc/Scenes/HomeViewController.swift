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
        //发起心跳包
        NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: #selector(heardBeat), userInfo: nil, repeats: true)
    } 
    
    func heardBeat()  {
       AppAPIHelper.commenAPI().heardBeat(CurrentUserHelper.shared.userInfo.uid, complete: { (result) in
        
        }, error: errorBlockFunc())
    }
}
