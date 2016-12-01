//
//  PhotoWallViewController.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

class PhotoWallViewController: BaseListTableViewController, OEZTableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(PhotoWallCell.self)
    }
    
    override func didRequest() {
        didRequestComplete(["","","","","","","","","",""]);
    }
//    
//    //MARK: - TableView
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 2 : 3
//    }
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3
//    }
    
    
    
}
