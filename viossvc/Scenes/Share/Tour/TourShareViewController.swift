//
//  TourShareViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class TourShareViewController: BaseListTableViewController {
 
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
    
    
    override func didRequest() {
//        didRequestComplete([[""],["","","","","","","","","",""]]);
        AppAPIHelper.tourShareAPI().list(0, count: 20, type: 0, complete: completeBlockFunc(), error: errorBlockFunc())
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
            let viewController:TourShareDetailViewController = storyboardViewController();
            self.navigationController?.pushViewController(viewController, animated: true);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(TourShareListViewController) {
            segue.destinationViewController.setValue(sender?.tag, forKey: "listType");
        }
    }
}
