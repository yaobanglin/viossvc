//
//  TourShareViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class TourShareViewController: BaseListTableViewController,OEZTableViewDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.registerNib(TourShareCell.self, forCellReuseIdentifier: "TourShareCell1");
//        tableView.registerNib(TourLeaderShareCell.self, forCellReuseIdentifier: "TourLeaderShareCell");
    }
    
    override func isSections() -> Bool {
        return true;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ?  105 : TourShareCell.calculateHeightWithData(nil);
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:TableViewHeaderView? = TableViewHeaderView.loadFromNib();
        view?.titleLabel.text = section == 0 ? "V领队分享" : "推荐分享";
        return view;
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  section == 0 ? 1 : dataSource![section].count
    }
    override func tableView(tableView: UITableView, cellIdentifierForRowAtIndexPath indexPath: NSIndexPath) -> String? {

        return  indexPath.section == 0 ? "TourLeaderShareCell" : super.tableView(tableView, cellIdentifierForRowAtIndexPath: indexPath)
        
    }
    
    override func tableView(tableView: UITableView, cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
  
        return indexPath.section == 0 ? dataSource![0] : super.tableView(tableView, cellDataForRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didAction action: Int, data: AnyObject!) {
        print(data as! Int)
        
        
    }
    
    

    override func didRequest() {
        var array : [[AnyObject]] = []
        

        
        AppAPIHelper.tourShareAPI().list(0, count: AppConst.DefaultPageSize, type: 0, complete: {[weak self] (obj) in
            if obj != nil  {
                  array.append(obj! as! [TourShareModel])
                
            }
            else {
                array.append([])
            }
            if array.count > 1 {
                
                self?.didRequestComplete(array)
            }
            
            }, error: errorBlockFunc())
        
        
        AppAPIHelper.tourShareAPI().type({ [weak self](obj) in
            if obj != nil  {
                
                if array.count > 0 {
                    array.insert(obj! as! [TourShareTypeModel], atIndex: 0)
                }
                else {
                    array = [obj! as! [TourShareTypeModel]]
                }
                
            }else {
                array.append([])
            }
            if array.count > 1 {
                
                self?.didRequestComplete(array)
            }
            
            }, error: errorBlockFunc())

        
}
    
    override func didRequestComplete(data: AnyObject?) {
  
        super.didRequestComplete(data)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let model = self.tableView(tableView, cellDataForRowAtIndexPath: indexPath) as? TourShareModel
            let viewController:TourShareDetailViewController = storyboardViewController()
            viewController.share_id = model!.share_id
            viewController.title = model!.share_theme
            self.navigationController?.pushViewController(viewController, animated: true);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(TourShareListViewController) {
            segue.destinationViewController.setValue(sender?.tag, forKey: "listType");
        }
    }
}
