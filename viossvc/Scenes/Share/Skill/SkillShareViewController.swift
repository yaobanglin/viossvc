//
//  SkillShareViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class SkillShareViewController: BasePageListTableViewController,OEZTableViewDelegate {

    var banners:[SkillBannerModel]? = []
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.registerClass(CommTableViewBannerCell.self, forCellReuseIdentifier: "SkillShareCell")
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return banners?.count > 0 ? 1 : 0;
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        if indexPath.section == 0 {
            return banners;
        }
        return super.tableView(tableView, cellDataForRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didSelectColumnAtIndex column: Int) {
        let model = banners?[column]
        pushSkillShareDetailViewController(model!.share_id)
    }
    
    func pushSkillShareDetailViewController(share_id:Int) {
        navigationController?.pushViewControllerWithIdentifier(SkillShareDetailViewController.className(), animated: true, valuesForKeys: ["share_id":share_id])
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataSource?[indexPath.row] as? SkillShareModel
        if model != nil {
            pushSkillShareDetailViewController(model!.share_id)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return banners?.count > 0 ? (UIScreen.width() * 125.0 / 375.0) : 0
        }
        return 110;
    }
    
    override func didRequest(pageIndex: Int) {
        let last_id:Int = pageIndex == 1 ? 0 : (dataSource?.last as! SkillShareModel).share_id
        AppAPIHelper.skillShareAPI().list(last_id, count: 5, complete: { [weak self] (model) in
                self?.didRequestComplete(model)
            }, error:errorBlockFunc())
    }
    
    override func didRequestComplete(data: AnyObject?) {
        let model = data as? SkillShareListModel
        if model != nil && pageIndex == 1  {
           banners = model!.banner_list
        }
        super.didRequestComplete(model?.data_list);
    }
}
