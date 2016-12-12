//
//  ShareListViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class TourShareListViewController: BasePageListTableViewController , OEZTableViewDelegate {
//    var listType:Int = 0;
//    var typeName: String
    var typeModel : TourShareTypeModel = TourShareTypeModel()
    
//    var typeNames:[String] = ["美食","住宿","景点","娱乐"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        listType = listType < typeNames.count ? listType : 0 ;
        title = typeModel.type_title;
        tableView.registerNib(TourShareCell.self, forCellReuseIdentifier: "TourShareListCell");
        
        switch typeModel.type_title {
        case "美食":
            MobClick.event(AppConst.Event.share_eat)
            break
        case "娱乐":
            MobClick.event(AppConst.Event.share_fun)
            break
        case "住宿":
            MobClick.event(AppConst.Event.share_hotel)
            break
        case "景点":
            MobClick.event(AppConst.Event.share_travel)
            break
        default:
            break
        }
    }
    
    override func isCalculateCellHeight() -> Bool {
        return true;
    }
    
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:TableViewHeaderView? = TableViewHeaderView.loadFromNib();
        view?.titleLabel.text = typeModel.type_title + "分享";
        return view;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataSource?[indexPath.row] as? TourShareModel
        let viewController:TourShareDetailViewController = storyboardViewController()
        viewController.share_id = model!.share_id
        viewController.title = model!.share_theme
        self.navigationController?.pushViewController(viewController, animated: true);

    }
    
    func tableView(tableView: UITableView!, rowAtIndexPath indexPath: NSIndexPath!, didAction action: Int, data: AnyObject!) {
        if UInt(action) == AppConst.Action.CallPhone.rawValue {
            let model = self.tableView(tableView, cellDataForRowAtIndexPath: indexPath) as? TourShareModel
            if model?.telephone != nil {
                didActionTel(model!.telephone)
            }
        }
    }
    
    
    
    override func didRequest(pageIndex: Int) {
        
        let last_id:Int = pageIndex == 1 ? 0 : (dataSource?.last as! TourShareModel).share_id
        
         AppAPIHelper.tourShareAPI().list(last_id, count: AppConst.DefaultPageSize, type: typeModel.type_id, complete: completeBlockFunc(), error: errorBlockFunc())
    }

}
