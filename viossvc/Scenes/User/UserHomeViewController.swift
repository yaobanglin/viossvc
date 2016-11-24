//
//  UserHomeViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class UserHomeViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRefreshControl();
        self.title = "个人中心";
    }
    
    override func autoRefreshLoad() -> Bool {
        return false;
    }

    override func didRequest() {
        self.performSelector(#selector(endRefreshing), withObject: nil, afterDelay: 2);
    }

}
