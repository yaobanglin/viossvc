//
//  PhotoWallViewController.swift
//  viossvc
//
//  Created by 陈奕涛 on 16/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

class PhotoWallViewController: BasePageListTableViewController, OEZTableViewDelegate {
    
    var page = 1
    
    var date:[String] = []
    
    var array:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.registerClass(PhotoWallCell.self, forCellReuseIdentifier: "PhotoWallCell")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        didRequest()
    }
    
    func rightItemTapped() {
        
        
    }
    
    override func isSections() -> Bool {
        return true
    }
    
    override func didRequest(pageIndex: Int) {
        let requestModel = PhotoWallRequestModel()
        requestModel.uid = CurrentUserHelper.shared.userInfo.uid
        requestModel.size = 20
        requestModel.num = pageIndex
        AppAPIHelper.userAPI().photoWallRequest(requestModel, complete: completeBlockFunc(), error: { (error) in
            NSLog("err")
        })
    }
    
    override func didRequest() {
        didRequest(1)
    }
    
    override func didRequestComplete(data: AnyObject?) {
        let model = data as? PhotoWallModoel
        
        if model != nil && model?.photo_list.count > 0 {
            array.removeAll()
            date.removeAll()
            var subArray:[PhotoModel] = []
            var day = ""
            for photo in model!.photo_list {
                let time = photo.upload_time! // "2016-12-02 17:37:46"
                if #available(iOS 9.0, *) {
                    let end = time.localizedStandardRangeOfString(" ")
                    let sub = time.substringToIndex(end!.startIndex)
                    if day == "" {
                        day = sub
                    }
                    if day != sub {
                        array.append(subArray)
                        date.append(day)
                        subArray = []
                        day = sub
                    }
                    subArray.append(photo)
                } else {
                    // Fallback on earlier versions
                }
            }
            array.append(subArray)
            date.append(day)
            
            dataSource = array
            super.didRequestComplete(array)
        }
        
    }
    
    //MARK: - TableView
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return date[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return array.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = array[section].count
        return cnt / 3 + (cnt % 3 > 0 ? 1 : 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoWallCell", forIndexPath: indexPath) as? PhotoWallCell
        if cell != nil {
            let secArr = array[indexPath.section]
            var arr:[AnyObject] = []
            for i in indexPath.row*3..<secArr.count {
                arr.append(secArr[i])
            }
            cell?.update(arr)
        }
        
        return cell ?? PhotoWallCell()
    }
    
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didSelectColumnAtIndex column: Int) {
        NSLog("\(indexPath.section) = \(indexPath.row) = \(column)")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    //MARK: - PhotoWallDelegate
    func refreshList() {   
        didRequest()
    }
    
}
