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
    
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didAction action: Int, data: AnyObject!) {
        
    }
    
    
    
    override func didRequest(pageIndex: Int) {
  
        AppAPIHelper.tourShareAPI().list(0, count: AppConst.DefaultPageSize, type: 0, complete: completeBlockFunc(), error: errorBlockFunc())
    }
    override func didRequest() {

//        AppAPIHelper.tourShareAPI().type(completeBlockFunc(), error: errorBlockFunc())
    }
    
    override func didRequestComplete(data: AnyObject?) {
        var array:[[AnyObject]] = [[""],[]]
        if data != nil {
            array[1].appendContentsOf(data as! [AnyObject])
        }
        super.didRequestComplete(array)
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
