//
//  ShareListViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class TourShareListViewController: BasePageListTableViewController {
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
    
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:TableViewHeaderView? = TableViewHeaderView.loadFromNib();
        view?.titleLabel.text = typeNames[listType] + "分享";
        return view;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController:TourShareDetailViewController = storyboardViewController();
        navigationController?.pushViewController(viewController, animated: true);
    }
    
    override func didRequest(pageIndex: Int) {
        var datas:[String]? = ["","","","","","","","","",""];
        if pageIndex == 5  {
            datas = nil;
        }
        didRequestComplete(datas);
    }

}
