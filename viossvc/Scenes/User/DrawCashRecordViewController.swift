//
//  DrawCashRecordViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/27.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class DrawCashRecordCell: OEZTableViewCell {
    
}

class DrawCashRecordViewController: BaseListTableViewController {
    override func didRequest() {
        didRequestComplete(["","","","","","","","","",""]);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
    }
}
