//
//  BaseCustomTableViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//
import UIKit

class BaseCustomTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,TableViewHelperProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    
    var tableViewHelper:TableViewHelper = TableViewHelper();
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView();
        
    }
    
    
    final func initTableView() {
        if tableView == nil  {
            for view:UIView in self.view.subviews {
                if view.isKindOfClass(UITableView) {
                    tableView = view as? UITableView;
                    break;
                }
            }
        }
        if tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame:CGRectMake(0,0,0,0.5));
        }
        tableView.delegate = self;
        tableView.dataSource = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:TableViewHelperProtocol
    
    func isSections() ->Bool {
        return false;
    }
    
    func isCacheCellHeight() -> Bool {
        return false;
    }
    
    func isCalculateCellHeight() ->Bool {
       return isCacheCellHeight();
    }
    
    func tableView(tableView:UITableView ,cellIdentifierForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return tableViewHelper.tableView(tableView, cellIdentifierForRowAtIndexPath: indexPath, controller: self);
    }
    
    func tableView(tableView:UITableView ,cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        return nil;
    }
    //MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableViewHelper.tableView(tableView, cellForRowAtIndexPath: indexPath, controller: self);
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableViewHelper.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath, controller: self);
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if( isCalculateCellHeight() ) {
            let cellHeight:CGFloat = tableViewHelper.tableView(tableView, heightForRowAtIndexPath: indexPath, controller: self);
            if( cellHeight != CGFloat.max ) {
                return cellHeight;
            }
        }
        return tableView.rowHeight;
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }

}

class BaseCustomRefreshTableViewController :BaseCustomTableViewController {
    
    override  func viewDidLoad() {
        super.viewDidLoad();
        self.setupRefreshControl();
    }
    
    internal func didRequestComplete(data:AnyObject?) {
        endRefreshing();
        self.tableView.reloadData();
        
    }

    func completeBlockFunc()->CompleteBlock {
        return { [weak self] (obj) in
            self?.didRequestComplete(obj)
        }
    }
    
    deinit {
        performSelectorRemoveRefreshControl();
    }
}


class BaseCustomListTableViewController :BaseCustomRefreshTableViewController {
    private var dataSource:Array<AnyObject>?;
    
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


class BaseCustomPageListTableViewController :BaseCustomListTableViewController {
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
