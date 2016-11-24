//
//  TourShareDetailViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class TourShareDetailViewController: BaseCustomRefreshTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(CommTableViewBannerCell.self, forCellReuseIdentifier: "TourShareDetailCell")
        tableViewHelper.addCacheCellHeight(UIScreen.width() * 150.0 / 375.0, indexPath: NSIndexPath(forItem: 0, inSection: 0));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func isCacheCellHeight() ->Bool {
        return true;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 10 : 0;
    }
    
    override func tableView(tableView: UITableView, cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        if indexPath.section == 0  {
            return ["test1","test3","test1","test3","test1","test3"]
        }
        return super.tableView(tableView, cellDataForRowAtIndexPath: indexPath);
    }
    
    
    override func didRequest() {
        didRequestComplete(nil);
    }

}
