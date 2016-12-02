//
//  ChatSessionViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/28.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class ChatListViewController: BaseListTableViewController {
    
    override func didRequest() {
        didRequestComplete(["","","","","","","","","",""]);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
                    let viewController:ChatInteractionViewController = storyboardViewController()
                    viewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(viewController, animated: true);
    }
    

}
