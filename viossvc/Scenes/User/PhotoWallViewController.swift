//
//  PhotoWallViewController.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

class PhotoWallViewController: BasePageListTableViewController, OEZTableViewDelegate {
    
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(PhotoWallCell.self)
        
    }
    
    func rightItemTapped() {
        
        
    }
    
    override func isSections() -> Bool {
        return false
    }
    
    override func didRequest(pageIndex: Int) {
        let requestModel = PhotoWallRequestModel()
        requestModel.uid = CurrentUserHelper.shared.userInfo.uid
        requestModel.size = 10
        requestModel.num = page
        AppAPIHelper.userAPI().photoWallRequest(requestModel, complete: completeBlockFunc(), error: errorBlockFunc())
    }
    
//    override func didRequest() {
//        didRequest(1)
//    }
    
    override func didRequestComplete(data: AnyObject?) {
        let array = data as? Array<PhotoWallModel>
        
        if data != nil && array?.count > 0 {
            dataSource = data as? Array<AnyObject>
        }
        super.didRequestComplete(data)
    }

    //MARK: - TableView
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0*(UIScreen.mainScreen().bounds.height/667.0)
    }

    //MARK: - PhotoWallDelegate
    func refreshList() {   
        didRequest()
    }
    
}
