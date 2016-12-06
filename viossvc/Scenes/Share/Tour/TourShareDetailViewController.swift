//
//  TourShareDetailViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/29.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class TourShareDetailViewController: BaseCustomRefreshTableViewController {

    var share_id:Int = 0
    var tourShareModel:TourShareDetailModel!
    @IBOutlet weak var telPhoneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(CommTableViewBannerCell.self, forCellReuseIdentifier: "TourShareDetailCell")
        tableViewHelper.addCacheCellHeight(UIScreen.width() * 150.0 / 375.0, indexPath: NSIndexPath(forItem: 0, inSection: 0));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func isCacheCellHeight() ->Bool {
        return true;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return tourShareModel != nil ? 3 : 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 10 : 0;
    }
    
    override func tableView(tableView: UITableView, cellDataForRowAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        if indexPath.section == 0  {
            return [tourShareModel.detail_pic]
        }
        return tourShareModel
    }
    
    override func didRequest() {
        AppAPIHelper.tourShareAPI().detail(share_id, complete: { [weak self] (model) in
                self?.didRequestComplete(model)
            }, error: errorBlockFunc())
    }
    
    
    override func didRequestComplete(data: AnyObject?) {
        tourShareModel = data as? TourShareDetailModel
         super.didRequestComplete(data)
    }
    
    @IBAction func didActionTelPhone(sender: AnyObject) {
        if let telephone = tourShareModel.telephone {
            didActionTel(telephone)
        }
    }

}
