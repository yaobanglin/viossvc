//
//  ShareListViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class TourShareListViewController: BasePageListTableViewController , OEZTableViewDelegate {
    var listType:Int = 0;
    var typeNames:[String] = ["美食","住宿","景点","娱乐"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        listType = listType < typeNames.count ? listType : 0 ;
        title = typeNames[listType];
        tableView.registerNib(TourShareCell.self, forCellReuseIdentifier: "TourShareListCell");
    }
    
    override func isCalculateCellHeight() -> Bool {
        return true;
    }
    
    
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didAction action: Int, data: AnyObject!) {
        
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:TableViewHeaderView? = TableViewHeaderView.loadFromNib();
        view?.titleLabel.text = typeNames[listType] + "分享";
        return view;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataSource?[indexPath.row] as? TourShareModel
        let viewController:TourShareDetailViewController = storyboardViewController()
        viewController.share_id = model!.share_id
        viewController.title = model!.share_theme
        self.navigationController?.pushViewController(viewController, animated: true);

    }
    
    override func didRequest(pageIndex: Int) {
        
        let last_id:Int = pageIndex == 1 ? 0 : (dataSource?.last as! TourShareModel).share_id
        
         AppAPIHelper.tourShareAPI().list(last_id, count: AppConst.DefaultPageSize, type: 0, complete: completeBlockFunc(), error: errorBlockFunc())
    }

}
