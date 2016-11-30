//
//  BaseTableViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation
class BaseTableViewController: UITableViewController , TableViewHelperProtocol {
    
    var tableViewHelper:TableViewHelper = TableViewHelper();
    
    override  func viewDidLoad() {
        super.viewDidLoad();
        if tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame:CGRectMake(0,0,0,0.5));
        }
    }
    
    //MARK:TableViewHelperProtocol
    func isCacheCellHeight() -> Bool {
        return false;
    }
    
    func isCalculateCellHeight() ->Bool {
        return isCacheCellHeight();
    }
    
    func isSections() ->Bool {
        return false;
    }
    
    func tableView(tableView:UITableView ,cellIdentifierForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return tableViewHelper.tableView(tableView, cellIdentifierForRowAtIndexPath: indexPath, controller: self);
    }
    
    func tableView(tableView:UITableView ,cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        return nil;
    }
    
    //MARK: -UITableViewDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = super.tableView(tableView,cellForRowAtIndexPath:indexPath);
        if cell == nil {
            cell = tableViewHelper.tableView(tableView, cellForRowAtIndexPath: indexPath, controller: self);
        }
        return cell!;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableViewHelper.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath, controller: self);
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        if( isCalculateCellHeight() ) {
            let cellHeight:CGFloat = tableViewHelper.tableView(tableView, heightForRowAtIndexPath: indexPath, controller: self);
            if( cellHeight != CGFloat.max ) {
                return cellHeight;
            }
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath);
    }
    
    
}
class BaseRefreshTableViewController :BaseTableViewController {
    
    override  func viewDidLoad() {
        super.viewDidLoad();
        self.setupRefreshControl();
    }

   internal func completeBlockFunc()->CompleteBlock {
        return { [weak self] (obj) in
            self?.didRequestComplete(obj)
        }
    }

   internal func didRequestComplete(data:AnyObject?) {
        endRefreshing();
        self.tableView.reloadData();
    }
    
    
    deinit {
        performSelectorRemoveRefreshControl();
    }
}


class BaseListTableViewController :BaseRefreshTableViewController {
    internal var dataSource:Array<AnyObject>?;
    
    override func didRequestComplete(data: AnyObject?) {
        dataSource = data as? Array<AnyObject>;
        super.didRequestComplete(dataSource);
        
    }
    
   //MARK: -UITableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count:Int = dataSource != nil ? 1 : 0;
        if  isSections() && count != 0 {
            count =  dataSource!.count;
        }
        return count;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var datas:Array<AnyObject>? = dataSource;
        if  dataSource != nil && isSections()  {
            datas = dataSource![section] as? Array<AnyObject>;
            
        }
        return datas == nil ? 0 : datas!.count;
    }
    
    //MARK:TableViewHelperProtocol
    override func tableView(tableView:UITableView ,cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        var datas:Array<AnyObject>? = dataSource;
        if dataSource != nil && isSections() {
            datas = dataSource![indexPath.section] as? Array<AnyObject>;
        }
        return  (datas != nil && datas!.count > indexPath.row ) ? datas![indexPath.row] : nil;
    }
    
}


class BasePageListTableViewController :BaseListTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        setupLoadMore();
    }
    
    
    override func didRequestComplete(data: AnyObject?) {
        tableViewHelper.didRequestComplete(&self.dataSource,
                                           pageDatas: data as? Array<AnyObject>, controller: self);
        super.didRequestComplete(self.dataSource);
    }
    
    deinit {
        removeLoadMore();
    }
}